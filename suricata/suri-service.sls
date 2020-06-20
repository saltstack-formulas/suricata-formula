# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "suricata/map.jinja" import host_lookup as config with context %}

# Make sure suricata service is running and restart if needed
service-suricata:
  service.running:
    - name: suricata.service
    - enable: True
    - reload: True
    - require:
      - pkg: package-install-suricata
    - watch:
      - file: {{ config.suricata.base_dir }}/{{ config.suricata.config_file }}

# Make sure netcfg@ service is running and enabled
{% if config.suricata.interfaces.capture.enable == 'True' %}
service-netcfg@{{ config.suricata.interfaces.capture.device_names }}:
  service.running:
    - name: netcfg@{{ config.suricata.interfaces.capture.device_names }}
    - enable: True
    - require:
      - file: /usr/lib/systemd/system/netcfg@.service
      - network: network_configure_{{ config.suricata.interfaces.capture.device_names }}
{% endif %}
