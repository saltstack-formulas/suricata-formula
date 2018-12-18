{% from "suricata/map.jinja" import host_lookup as config with context %}

# Install epel for RHEL based systems
{% if salt.grains.get('os_family') == 'RedHat' %}
package-install-epel-suricata:
  pkg.installed:
    - pkgs:
      - epel-release          # Base install
    - refresh: True

# Install prereqs for RHEL based systems
package-install-prereqs-suricata:
  pkg.installed:
    - pkgs:
       - curl
       - gawk
       - gperftools-libs
    - refresh: True

# Install prereqs for Debian based systems
{% elif salt.grains.get('os_family') == 'Debian' %}
package-install-prereqs-suricata:
  pkg.installed:
    - pkgs:
       - curl
       - gawk
    - refresh: True
{% endif %} # End RedHat/Debian

