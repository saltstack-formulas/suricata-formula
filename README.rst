================
suricata-formula
================

A saltstack formula to install suricata on RHEL or Debian based systems.

Supports one capture interface at the moment. Adding ability to control multiple capture interfaces is on the TODO list  


Optional
================

Formulas exist to help with installation and management of
other components such as pf_ring.

pfring-formula  
https://github.com/saltstack-formulas/pfring-formula

Available states
================

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

.. contents::
    :local:

``suri-prereqs``
------------
Install prerequisite packages

``suri-package``
------------
Install suricata packages and optionaly packages for suricata-update if needed.

``suri-config``
------------
Manage configuration file placement

``suri-service``
------------
Manage suricata service and a service to manage promiscuous mode of defined network interfaces on RHEL/CentOS 7 or Debian systems.

``suri-rules``
------------
Manage suricata rules with suricata-update package. Creates modify, drop, enable, and disable templates along with rule file management.

``suri-cron``
------------
Manage optional suricata-update cron to setup a daily job for suricata-update.
