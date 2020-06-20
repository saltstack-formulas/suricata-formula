suricata-formula
================

|img_travis|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/suricata-formula.svg?branch=master
      :alt: Travis CI Build Status
   :scale: 100%

A saltstack formula to install suricata on RHEL or Ubuntu based systems.

On RHEL based systems, epel is required and will default to whichever version matches the OS platform.  
Suricata packages for suricata **v5.0.x** are part of the **RHEL8** ecosystem and suricata **v4.1.x** is part of the **RHEL7** ecosystem.

There is no such versioning weirdness with Ubuntu distros, which allow installing the latest suricata.

Supports one capture interface at the moment. Adding ability to control multiple capture interfaces is on the TODO list  

.. contents:: **Table of Contents**
         :depth: 1

Optional
--------

Formulas exist to help with installation and management of
other optional components such as pf_ring.

pfring-formula  
https://github.com/saltstack-formulas/pfring-formula

General notes
-------------

.. note::

    The ``FORMULA`` file, contains information about the version of this formula, tested OS and OS families, and the minimum tested version of salt.

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
----------------

.. contents::
    :local:


``suricata``
^^^^^^^^^^^^
*Meta-state (This is a state that includes other states)*.

Installs **suricata** and it's requirements, manages the configuration file, and starts the service.

``suricata.suri-prereqs``
^^^^^^^^^^^^^^^^^^^^^^^^^
Install prerequisite packages

``suricata.suri-package``
^^^^^^^^^^^^^^^^^^^^^^^^^
Install suricata packages and optionaly packages for suricata-update if needed.

``suricata.suri-config``
^^^^^^^^^^^^^^^^^^^^^^^^
Manage configuration file placement and user configuration

``suricata.suri-service``
^^^^^^^^^^^^^^^^^^^^^^^^^
Manage suricata service and a service to manage promiscuous mode of defined network interfaces on RHEL/CentOS 7 or Debian systems.

``suricata.suri-rules``
^^^^^^^^^^^^^^^^^^^^^^^
Manage suricata rules with suricata-update package. Creates modify, drop, enable, and disable templates along with rule file management.

``suricata.suri-cron``
^^^^^^^^^^^^^^^^^^^^^^
Manage optional suricata-update cron to setup a daily job for suricata-update.

Testing
-------

Linux testing is done with **kitchen-salt**.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,  
e.g. ``debian-9-2019-2-py3``.

Test options
^^^^^^^^^^^^

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^
Creates the docker instance and runs the **suricata** main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^
Runs the **inspec** tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^
Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^
Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^
Gives you SSH access to the instance for manual testing if automated testing fails.
