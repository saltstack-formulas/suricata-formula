# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "suricata/map.jinja" import host_lookup as config with context %}
{% if config.suricata.use_suricata_update == 'True' %}

# Manage the suricata-update rules directory
{{ config.suricata.rules_path }}:
  file.directory:
    - makedirs: True
    - user: {{ config.suricata.user }}
    - group: root
    - dir_mode: '0750'
    - file_mode: '0640'

# Manage the suricata-update update directory
{{ config.suricata.update_path }}:
  file.directory:
    - makedirs: True
    - user: {{ config.suricata.user }}
    - group: root
    - dir_mode: '0750'
    - file_mode: '0640'

# Manage the suricata config file
{{ config.suricata.base_dir }}/{{ config.suricata.update_config |regex_replace('suricata-', '', ignorecase=True) }}:
  file.managed:
    - source: salt://suricata/files/{{ config.suricata.update_config }}
    - template: jinja
    - user: {{ config.suricata.user }}
    - group: root
    - mode: '0600'

# Manage suricata threshold.config file
{{ config.suricata.base_dir }}/{{ config.suricata.threshold_file }}:
  file.managed:
    - source: salt://suricata/files/{{ config.suricata.threshold_file }}
    - user: {{ config.suricata.user }}
    - group: root
    - mode: '0600'

# Manage the suricata disable.conf file for rule managment
{{ config.suricata.base_dir }}/{{ config.suricata.disable_conf }}:
  file.managed:
    - source: salt://suricata/files/{{ config.suricata.disable_conf }}
    - user: {{ config.suricata.user }}
    - group: root
    - mode: '0600'

# Manage the suricata enable.conf file for rule managment
{{ config.suricata.base_dir }}/{{ config.suricata.enable_conf }}:
  file.managed:
    - source: salt://suricata/files/{{ config.suricata.enable_conf }}
    - user: {{ config.suricata.user }}
    - group: root
    - mode: '0600'

# Manage the suricata drop.conf file for rule managment
{{ config.suricata.base_dir }}/{{ config.suricata.drop_conf }}:
  file.managed:
    - source: salt://suricata/files/{{ config.suricata.drop_conf }}
    - user: {{ config.suricata.user }}
    - group: root
    - mode: '0600'

# Manage the suricata modify.conf file for rule managment
{{ config.suricata.base_dir }}/{{ config.suricata.modify_conf }}:
  file.managed:
    - source: salt://suricata/files/{{ config.suricata.modify_conf }}
    - user: {{ config.suricata.user }}
    - group: root
    - mode: '0600'

# Run suricata-update for the first time
command-run-suricata-update:
  cmd.run:
    - name: suricata-update --reload-command='{{ config.suricata.reload_command }}'
    - creates: {{ config.suricata.update_path }}/cache/
    - runas: {{ config.suricata.user }}
    - shell: /bin/bash

{% endif %}
