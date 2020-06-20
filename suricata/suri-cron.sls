# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "suricata/map.jinja" import host_lookup as config with context %}
{% if config.suricata.use_suricata_update == 'True' %}
{% if config.suricata.use_suricata_update_cron == 'True' %}

# Make sure cron is installed
{% if salt.grains.get('os_family') == 'RedHat' %}
  {% set cron_package = 'cronie' %}
{% elif salt.grains.get('os_family') == 'Debian' %}
  {% set cron_package = 'cron' %}
{% endif %}
package-install-cron-suricata:
  pkg.installed:
    - pkgs:
      - {{ cron_package }}
    - refresh: True

# Setup Cron for suricata-update that runs daily at midnight
su -s /bin/bash -c "suricata-update --reload-command='{{ config.suricata.reload_command }}'" {{ config.suricata.user }}:
  cron.present:
    - comment: "Update suricata IDS rules"
    - identifier: "Suricata_Update"
    - user: root
    - minute: '0'
    - hour: '0'

{% endif %}
{% endif %}
