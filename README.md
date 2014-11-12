puppet-softwareAutoInstall
==========================

Automatic installation of a set of softwares using EeasyBuild

# Description

This Puppet module will install a defined set of software using EasyBuild.
It has been created to answer a need at the University of Luxembourg, so the terminology is the one that is used there.
By "core" we mean the set of software that consists of a reduced number of software that are officially supported on the platform.
By "experimental" we mean the set of software that consists of a large number of software that are not all officially supported by the platform.

*Please note that this module has been written in order to be used on an installation of EasyBuild using my other module : https://github.com/sylmarien/puppet-easybuild .
Also it is highly unlikely that it will work under any other circumstances !*

# Usage

When declaring the module, use the following syntax:
```
class { 'softwareAutoInstall':
  branch => yourBranch,
  easybuildversion => EBversion,
  }
```
Where yourBranch is a string containing the name of the branch you want to install (either "core" or "experimental").  
And EBversion the version of EasyBuild you want to use to install these softwares. (e.g: 1.15.1)

Note: By default, the "core" set of software will be installed and your default version of EasyBuild will be used, so if you simply do:  
  `include softwareAutoInstall`  
this is the set that will be installed.

# Customize installation

If you want to change your environment variables (for example to install your softwares in a separate directory), just put a file named variables.sh in the files directory of the module that contain **all** the variables you need to do your installation.
**ALL**.
Not only the one you want to change compared to your usual ones.
If you don't put such a file, then your default values will be used.
