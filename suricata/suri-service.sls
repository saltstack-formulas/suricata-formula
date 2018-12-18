{% from "suricata/map.jinja" import host_lookup as config with context %}

# Make sure suricata service is running and restart if needed
service-suricata:
  service.running:
    - name: suricata.service
    - enable: True
    - require:
      - pkg: package-install-suricata
      - network: network_configure_{{ config.suricata.interfaces.capture.device_names }}
    - watch:
      - file: {{ config.suricata.config_path }}

# Make sure netcfg@ service is running and enabled
service-netcfg@{{ config.suricata.interfaces.capture.device_names }}:
  service.running:
    - name: netcfg@{{ config.suricata.interfaces.capture.device_names }}
    - enable: True
    - require:
      - file: /usr/lib/systemd/system/netcfg@.service
      - network: network_configure_{{ config.suricata.interfaces.capture.device_names }}
