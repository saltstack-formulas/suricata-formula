{% from "suricata/map.jinja" import host_lookup as config with context %}

# Manage the suricata config file
{{ config.suricata.config_path }}:
  file.managed:
    - source: salt://suricata/files/suricata.yaml
    - template: jinja
    - user: {{ config.suricata.user }}
    - group: root
    - mode: '0600'

# Manage suricata file in sysconfig/default using template
{{ config.suricata.startup_overrides_path }}:
  file.managed:
    - source: salt://suricata/files/suricata.sysconfig
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

# Configure network options
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
