{% from "suricata/map.jinja" import host_lookup as config with context %}
{% if config.suricata.use_suricata_update == 'True' %}
{% if config.suricata.use_suricata_update_cron == 'True' %}

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
