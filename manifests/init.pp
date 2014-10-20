# File::      <tt>init.pp</tt>
# Author::    M. Schmitt (maxime.schmitt@ext.uni.lu)
# Copyright:: Copyright (c) 2014 M. Schmitt
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# = Class: softwareAutoInstall
#
# rtfm
#
# == Parameters:
#
# $ensure:: *Default*: 'present'. Ensure the presence (or absence) of softwareAutoInstall
#
# == Actions:
#
# Install and configure softwareAutoInstall
#
# == Requires:
#
# n/a
#
# == Sample Usage:
#
#     import softwareAutoInstall
#
# You can then specialize the various aspects of the configuration,
# for instance:
#
#         class { 'softwareAutoInstall':
#             ensure => 'present'
#         }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
#
# [Remember: No empty lines between comments and class definition]
#
class softwareAutoInstall(
    $ensure = $softwareAutoInstall::params::ensure,
    $branch = "core",
    $EasyBuildVersion = ""
)
inherits softwareAutoInstall::params
{
    info ("Configuring softwareAutoInstall (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("softwareAutoInstall 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    case $::operatingsystem {
        debian, ubuntu:         { include softwareAutoInstall::debian }
        redhat, fedora, centos: { include softwareAutoInstall::redhat }
        default: {
            fail("Module $module_name is not supported on $operatingsystem")
        }
    }
}

# ------------------------------------------------------------------------------
# = Class: softwareAutoInstall::common
#
# Base class to be inherited by the other softwareAutoInstall classes
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class softwareAutoInstall::common {

    # Load the variables used in this module. Check the softwareAutoInstall-params.pp file
    require softwareAutoInstall::params

    package { 'softwareAutoInstall':
        name    => "${softwareAutoInstall::params::packagename}",
        ensure  => "${softwareAutoInstall::ensure}",
    }
    # package { $softwareAutoInstall::params::extra_packages:
    #     ensure => 'present'
    # }
    Exec { path => $easybuild::params::path }

    if $softwareAutoInstall::ensure == 'present' {
      exec { 'install':
        user    => 'sw',
        command => "bash -c 'cd /tmp && sh install.py ${softwareAutoInstall::branch} ${softwareAutoInstall::EasyBuildVersion} && rm -f install.py && rm -f softwares.yaml'",
        umask   => '022',
        require => [ File [ 'install.py' ], File [ 'softwares.yaml' ] ],
      }

      file { 'install.py':
        ensure => present,
        path   => '/tmp/install.py',
        owner  => 'sw',
        mode   => '0755',
        source => 'puppet:///modules/softwareAutoInstall/install.py',
      }

      file { 'softwares.yaml':
        ensure => present,
        path   => '/tmp/softwares.yaml',
        owner  => 'sw',
        mode   => '0755',
        source => 'puppet:///modules/softwareAutoInstall/softwares.yaml',
      }
    }
}


# ------------------------------------------------------------------------------
# = Class: softwareAutoInstall::debian
#
# Specialization class for Debian systems
class softwareAutoInstall::debian inherits softwareAutoInstall::common { }

# ------------------------------------------------------------------------------
# = Class: softwareAutoInstall::redhat
#
# Specialization class for Redhat systems
class softwareAutoInstall::redhat inherits softwareAutoInstall::common { }



