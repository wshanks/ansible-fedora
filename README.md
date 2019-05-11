ansible-fedora
=========

This role configures Fedora the way I like for a desktop. Basically, it sets up some repos and installs some Flatpaks and rpms and does some configuration of Plasma. It assumes the Plasma desktop is installed.

Requirements
------------

A Fedora system with the Plasma desktop installed. One way to do this is with a NetInstall, selecting the KDE Plasma Workspaces environment and the Ansible Node add-on.

Example Playbook
----------------

    - hosts: workstations
      roles:
         - { role: ansible_fedora }

License
-------

0BSD
