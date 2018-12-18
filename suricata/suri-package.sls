{% from "suricata/map.jinja" import host_lookup as config with context %}

# Install suricata from a package repo
package-install-suricata:
  pkg.installed:
    - pkgs:
      - suricata
    - refresh: True
    - require_in:
      - service: service-suricata

{% if config.suricata.use_suricata_update == 'True' %}
# If using a version of suricata < v4.1, suricata-update is an add on.
# It is not bundled with the main install so we install it.

# Install pip and other required packages
pip-install-suricata:
  pkg.installed:
    - pkgs:
      - {{ config.suricata.python_pyyaml_pkg }}
      - {{ config.suricata.python_pip_pkg }}
    - refresh: True
    - unless: echo $(which suricata-update) |grep "no suricata-update"
    - require:
      - pkg: package-install-suricata

# Upgrade older versions of pip
pip-upgrade-suricata:
  cmd.run:
    - name: {{ config.suricata.python_pip_cmd }} install --upgrade pip
    - onlyif: {{ config.suricata.python_pip_cmd }} list --outdated |grep pip
    - unless: echo $(which suricata-update) |grep "no suricata-update"
    - require:
      - pkg: pip-install-suricata

# Install the built in suricata-update module
pip-package-install-suricata-update:
  cmd.run:
    - name: {{ config.suricata.python_pip_cmd }} install --upgrade suricata-update
    - onlyif: {{ config.suricata.python_pip_cmd }} list --outdated |grep suricata-update
    - unless: echo $(which suricata-update) |grep "no suricata-update"
    - require:
      - pkg: package-install-suricata
      - cmd: pip-upgrade-suricata

{% endif %}
