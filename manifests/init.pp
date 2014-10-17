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
    $ensure = $softwareAutoInstall::params::ensure
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

    if $softwareAutoInstall::ensure == 'present' {

        # Prepare the log directory
        file { "${softwareAutoInstall::params::logdir}":
            ensure => 'directory',
            owner  => "${softwareAutoInstall::params::logdir_owner}",
            group  => "${softwareAutoInstall::params::logdir_group}",
            mode   => "${softwareAutoInstall::params::logdir_mode}",
            require => Package['softwareAutoInstall'],
        }

        # Configuration file
        # file { "${softwareAutoInstall::params::configdir}":
        #     ensure => 'directory',
        #     owner  => "${softwareAutoInstall::params::configdir_owner}",
        #     group  => "${softwareAutoInstall::params::configdir_group}",
        #     mode   => "${softwareAutoInstall::params::configdir_mode}",
        #     require => Package['softwareAutoInstall'],
        # }
        # Regular version using file resource
        file { 'softwareAutoInstall.conf':
            path    => "${softwareAutoInstall::params::configfile}",
            owner   => "${softwareAutoInstall::params::configfile_owner}",
            group   => "${softwareAutoInstall::params::configfile_group}",
            mode    => "${softwareAutoInstall::params::configfile_mode}",
            ensure  => "${softwareAutoInstall::ensure}",
            #content => template("softwareAutoInstall/softwareAutoInstallconf.erb"),
            #source => "puppet:///modules/softwareAutoInstall/softwareAutoInstall.conf",
            #notify  => Service['softwareAutoInstall'],
            require => [
                        #File["${softwareAutoInstall::params::configdir}"],
                        Package['softwareAutoInstall']
                        ],
        }

        # # Concat version
        # include concat::setup
        # concat { "${softwareAutoInstall::params::configfile}":
        #     warn    => false,
        #     owner   => "${softwareAutoInstall::params::configfile_owner}",
        #     group   => "${softwareAutoInstall::params::configfile_group}",
        #     mode    => "${softwareAutoInstall::params::configfile_mode}",
        #     #notify  => Service['softwareAutoInstall'],
        #     require => Package['softwareAutoInstall'],
        # }
        # # Populate the configuration file
        # concat::fragment { "${softwareAutoInstall::params::configfile}_header":
        #     target  => "${softwareAutoInstall::params::configfile}",
        #     ensure  => "${softwareAutoInstall::ensure}",
        #     content => template("softwareAutoInstall/softwareAutoInstall_header.conf.erb"),
        #     #source => "puppet:///modules/softwareAutoInstall/softwareAutoInstall_header.conf",
        #     order   => '01',
        # }
        # concat::fragment { "${softwareAutoInstall::params::configfile}_footer":
        #     target  => "${softwareAutoInstall::params::configfile}",
        #     ensure  => "${softwareAutoInstall::ensure}",
        #     content => template("softwareAutoInstall/softwareAutoInstall_footer.conf.erb"),
        #     #source => "puppet:///modules/softwareAutoInstall/softwareAutoInstall_footer.conf",
        #     order   => '99',
        # }

        # PID file directory
        # file { "${softwareAutoInstall::params::piddir}":
        #     ensure  => 'directory',
        #     owner   => "${softwareAutoInstall::params::piddir_user}",
        #     group   => "${softwareAutoInstall::params::piddir_group}",
        #     mode    => "${softwareAutoInstall::params::piddir_mode}",
        # }

        file { "${softwareAutoInstall::params::configfile_init}":
            owner   => "${softwareAutoInstall::params::configfile_owner}",
            group   => "${softwareAutoInstall::params::configfile_group}",
            mode    => "${softwareAutoInstall::params::configfile_mode}",
            ensure  => "${softwareAutoInstall::ensure}",
            #content => template("softwareAutoInstall/default/softwareAutoInstall.erb"),
            #source => "puppet:///modules/softwareAutoInstall/default/softwareAutoInstall.conf",
            notify  =>  Service['softwareAutoInstall'],
            require =>  Package['softwareAutoInstall']
        }

        service { 'softwareAutoInstall':
            name       => "${softwareAutoInstall::params::servicename}",
            enable     => true,
            ensure     => running,
            hasrestart => "${softwareAutoInstall::params::hasrestart}",
            pattern    => "${softwareAutoInstall::params::processname}",
            hasstatus  => "${softwareAutoInstall::params::hasstatus}",
            require    => [
                           Package['softwareAutoInstall'],
                           File["${softwareAutoInstall::params::configfile_init}"]
                           ],
            subscribe  => File['softwareAutoInstall.conf'],
        }
    }
    else
    {
        # Here $softwareAutoInstall::ensure is 'absent'

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



