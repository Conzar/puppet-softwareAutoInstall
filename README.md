puppet-softwareAutoInstall
==========================

Automatic installation of a set of softwares using EeasyBuild

# Description

This Puppet module will install a defined set of software using EasyBuild.
It has been created to answer a need at the University of Luxembourg, so the terminology is the one that is used there.
By "core" we mean the set of software that consists of a reduced number of software that are officially supported on the platform.
By "experimental" we mean the set of software that consists of a large number of software that are not all officially supported by the platform.

# Usage

When declaring the module, use the following syntax:
```
class { 'softwareAutoInstall':
  branch => yourBranch,
  }
```
Where yourBranch is a string containing the name of the branch you want to install (either "core" or "experimental").

Note: By default, the "core" set of software will be installed, so if you simply do:
include softwareAutoInstall
this is the set that will be installed.
