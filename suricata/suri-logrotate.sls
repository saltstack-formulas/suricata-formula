# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "suricata/map.jinja" import host_lookup as config with context %}
{% if config.suricata.use_logrotate == 'True' %}

# Manage logrotate config for suricata
{{ config.suricata.logrotate_config }}:
  file.managed:
    - contents: |
        /var/log/suricata/*.log
        /var/log/suricata/*.json {
            daily
            rotate 7
            missingok
            notifempty
            compress
            create 640 {{ config.suricata.user }} {{ config.suricata.group }} 
            sharedscripts
            postrotate
                /bin/kill -HUP `cat /var/run/suricata.pid 2> /dev/null` 2> /dev/null || true
            endscript
        }
    - user: root
    - group: root
    - mode: '0644'

{% endif %}
