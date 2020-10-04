.. _readme:

suricata-formula
================

|img_travis| |img_sr|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/suricata-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/suricata-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release

A saltstack formula to install suricata on RHEL or Ubuntu based systems.

On RHEL based systems, epel is required and will default to whichever version matches the OS platform.
Suricata packages for suricata **v5.0.x** are part of the **RHEL8** ecosystem and suricata **v4.1.x** is part of the **RHEL7** ecosystem.

There is no such versioning weirdness with Ubuntu distros, which allow installing the latest suricata.

Supports one capture interface at the moment. Adding ability to control multiple capture interfaces is on the TODO list

   Credit: formula created by `@alias454 <https://github.com/alias454>`_.

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

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please pay attention to the ``pillar.example`` file and/or `Special notes`_ section.

Contributing to this repo
-------------------------

**Commit message formatting is significant!!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

Special notes
-------------

None.

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

Linux testing is done with ``kitchen-salt``.

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

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the **suricata** main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.

