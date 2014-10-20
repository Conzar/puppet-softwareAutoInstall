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
    $ensure = $softwareautoinstall::params::ensure,
    $branch = "core",
    $easybuildversion = ""
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
    require easybuild
    # Load the variables used in this module. Check the softwareAutoInstall-params.pp file
    require softwareautoinstall::params

    Exec { path => $softwareautoinstall::params::path }

    if $softwareautoinstall::ensure == 'present' {
      exec { 'install':
        user        => 'sw',
        command     => "bash -c 'cd /tmp && source variables.sh && python install.py ${softwareautoinstall::branch} ${softwareautoinstall::easybuildversion} && rm -f install.py && rm -f softwares.yaml'",
        umask       => '022',
        environment => 'HOME=/home/sw',
        require     => [ File [ 'install.py' ], File [ 'softwares.yaml' ], File [ 'variables.sh' ], Package [ "${softwareautoinstall::params::PyYaml}" ] ],
      }

      file { 'install.py':
        ensure => present,
        path   => '/tmp/install.py',
        owner  => 'sw',
        mode   => '0755',
        source => 'puppet:///modules/softwareautoinstall/install.py',
      }

      file { 'softwares.yaml':
        ensure => present,
        path   => '/tmp/softwares.yaml',
        owner  => 'sw',
        mode   => '0755',
        source => 'puppet:///modules/softwareautoinstall/softwares.yaml',
      }

      file { 'variables.sh':
        ensure  => present,
        path    => '/tmp/variables.sh',
        owner   => 'sw',
        mode    => '0755',
        source  => [
          'puppet:///modules/softwareautoinstall/variables.sh',
          '/etc/profile.d/easybuild.sh'
        ],
      }

      package { "${softwareautoinstall::params::PyYaml}":
        ensure => installed,
      }
    }
}


# ------------------------------------------------------------------------------
# = Class: softwareautoinstall::debian
#
# Specialization class for Debian systems
class softwareautoinstall::debian inherits softwareautoinstall::common { }

# ------------------------------------------------------------------------------
# = Class: softwareAutoInstall::redhat
#
# Specialization class for Redhat systems
class softwareautoinstall::redhat inherits softwareautoinstall::common { }



