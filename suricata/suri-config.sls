# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "suricata/map.jinja" import host_lookup as config with context %}

# Create suricata group if not exists
group-manage-{{ config.suricata.group }}:
  group.present:
    - name: {{ config.suricata.group }}
    - system: True

# Create suricata user if not exists
user-manage-{{ config.suricata.user }}:
  user.present:
    - name: {{ config.suricata.user }}
    - shell: /usr/sbin/nologin
    - system: True
    - groups:
      - {{ config.suricata.group }}
    - require:
      - group: group-manage-{{ config.suricata.group }}

# Configure init file for Ubuntu based installs
{% if grains['os_family'] == 'Debian' %}
/etc/init.d/{{ config.suricata.service_file |regex_replace('\.[a-z]+$', '', ignorecase=True) }}:
  file.managed:
    - source: salt://suricata/files/{{ config.suricata.service_file }}
    - template: jinja
    - user: root
    - group: root
    - mode: '0755'
{% endif %}

# Manage suricata sysconfig/default file using a template
{% if grains['os_family'] == 'RedHat' %}
  {% set overrides_file = 'sysconfig' %}
{% elif grains['os_family'] == 'Debian' %}
  {% set overrides_file = 'default' %}
{% endif %}
{{ config.suricata.startup_overrides_path }}:
  file.managed:
    - source: salt://suricata/files/suricata.{{ overrides_file }}
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

# Setup persistant tmpfile creation
/usr/lib/tmpfiles.d/suricata.conf:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        d /run/suricata 0755 {{ config.suricata.user }} {{ config.suricata.group }} -

# Manage suricata default_log_dir permissions
{{ config.suricata.default_log_dir }}:
  file.directory:
    - user: {{ config.suricata.user }}
    - group: root
    - dir_mode: '0750'
    - file_mode: '0640'
    - recurse:
      - user
      - group
      - mode
    - require:
      - service: service-suricata

# Manage suricata base_dir permissions
{{ config.suricata.base_dir }}:
  file.directory:
    - user: {{ config.suricata.user }}
    - group: root
    - dir_mode: '0750'
    - file_mode: '0640'
    - recurse:
      - user
      - group
      - mode

# Manage suricata config file
{{ config.suricata.base_dir }}/{{ config.suricata.config_file }}:
  file.managed:
    - source: salt://suricata/files/{{ config.suricata.config_file }}.{{ config.suricata.config_version }}
    - template: jinja
    - user: {{ config.suricata.user }}
    - group: root
    - mode: '0600'

# Use BPF config file
{% if config.suricata.bpf.use_BPFconf == 'True' %}
{{ config.suricata.base_dir }}/{{ config.suricata.bpf.bpf_rules_file }}:
  file.managed:
    - source: salt://suricata/files/{{ config.suricata.bpf.bpf_rules_file }}
    - user: {{ config.suricata.user }}
    - group: root
    - mode: '0600'
    - require_in:
      - service: service-suricata
{% endif %}

# Setup classification file
{{ config.suricata.base_dir }}/{{ config.suricata.classification_file }}:
  file.managed:
    - source: salt://suricata/files/{{ config.suricata.classification_file }}
    - user: {{ config.suricata.user }}
    - group: root
    - mode: '0644'

# Configure network options
{% if config.suricata.interfaces.capture.enable == 'True' %}
network_configure_{{ config.suricata.interfaces.capture.device_names }}:
  network.managed:
    - name: {{ config.suricata.interfaces.capture.device_names }}
    - enabled: True
    - retain_settings: True
    - type: eth
    - proto: none
    - autoneg: on
    - duplex: full
    - rx: off
    - tx: off
    - sg: off
    - tso: off
    - ufo: off
    - gso: off
    - gro: off
    - lro: off
    - require_in:
      - service: service-suricata
{% endif %}

# Manage systemd unit file to control promiscuous mode
/usr/lib/systemd/system/netcfg@.service:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true
    - contents: |
        [Unit]
        Description=Control promiscuous mode for interface %i
        After=network.target

        [Service]
        Type=oneshot
        ExecStart={{ config.suricata.interfaces.ip_binary_path }} link set %i promisc on
        ExecStop={{ config.suricata.interfaces.ip_binary_path }} link set %i promisc off
        RemainAfterExit=yes

        [Install]
        WantedBy=multi-user.target
