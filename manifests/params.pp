# File::      <tt>params.pp</tt>
# Author::    M. Schmitt (maxime.schmitt@ext.uni.lu)
# Copyright:: Copyright (c) 2014 M. Schmitt
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# = Class: softwareAutoInstall::params
#
# In this class are defined as variables values that are used in other
# softwareAutoInstall classes.
# This class should be included, where necessary, and eventually be enhanced
# with support for more OS
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# The usage of a dedicated param classe is advised to better deal with
# parametrized classes, see
# http://docs.puppetlabs.com/guides/parameterized_classes.html
#
# [Remember: No empty lines between comments and class definition]
#
class softwareAutoInstall::params {

    ######## DEFAULTS FOR VARIABLES USERS CAN SET ##########################
    # (Here are set the defaults, provide your custom variables externally)
    # (The default used is in the line with '')
    ###########################################

    # ensure the presence (or absence) of softwareAutoInstall
    $ensure = $softwareAutoInstall_ensure ? {
        ''      => 'present',
        default => "${softwareAutoInstall_ensure}"
    }

    # The Protocol used. Used by monitor and firewall class. Default is 'tcp'
    $protocol = $softwareAutoInstall_protocol ? {
        ''      => 'tcp',
        default => "${softwareAutoInstall_protocol}",
    }
    # The port number. Used by monitor and firewall class. The default is 22.
    $port = $softwareAutoInstall_port ? {
        ''      => 22,
        default => "${softwareAutoInstall_port}",
    }
    # example of an array variable
    $array_variable = $softwareAutoInstall_array_variable ? {
        ''      => [],
        default => $softwareAutoInstall_array_variable,
    }


    #### MODULE INTERNAL VARIABLES  #########
    # (Modify to adapt to unsupported OSes)
    #######################################
    # softwareAutoInstall packages
    $packagename = $::operatingsystem ? {
        default => 'softwareAutoInstall',
    }
    # $extra_packages = $::operatingsystem ? {
    #     /(?i-mx:ubuntu|debian)/        => [],
    #     /(?i-mx:centos|fedora|redhat)/ => [],
    #     default => []
    # }

    # Log directory
    $logdir = $::operatingsystem ? {
        default => '/var/log/softwareAutoInstall'
    }
    $logdir_mode = $::operatingsystem ? {
        default => '750',
    }
    $logdir_owner = $::operatingsystem ? {
        default => 'root',
    }
    $logdir_group = $::operatingsystem ? {
        default => 'adm',
    }

    # PID for daemons
    # $piddir = $::operatingsystem ? {
    #     default => "/var/run/softwareAutoInstall",
    # }
    # $piddir_mode = $::operatingsystem ? {
    #     default => '750',
    # }
    # $piddir_owner = $::operatingsystem ? {
    #     default => 'softwareAutoInstall',
    # }
    # $piddir_group = $::operatingsystem ? {
    #     default => 'adm',
    # }
    # $pidfile = $::operatingsystem ? {
    #     default => '/var/run/softwareAutoInstall/softwareAutoInstall.pid'
    # }

    # softwareAutoInstall associated services
    $servicename = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/ => 'softwareAutoInstall',
        default                 => 'softwareAutoInstall'
    }
    # used for pattern in a service ressource
    $processname = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/ => 'softwareAutoInstall',
        default                 => 'softwareAutoInstall'
    }
    $hasstatus = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/        => false,
        /(?i-mx:centos|fedora|redhat)/ => true,
        default => true,
    }
    $hasrestart = $::operatingsystem ? {
        default => true,
    }

    # Configuration directory & file
    # $configdir = $::operatingsystem ? {
    #     default => "/etc/softwareAutoInstall",
    # }
    # $configdir_mode = $::operatingsystem ? {
    #     default => '0755',
    # }
    # $configdir_owner = $::operatingsystem ? {
    #     default => 'root',
    # }
    # $configdir_group = $::operatingsystem ? {
    #     default => 'root',
    # }

    $configfile = $::operatingsystem ? {
        default => '/etc/softwareAutoInstall.conf',
    }
    $configfile_init = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/ => '/etc/default/softwareAutoInstall',
        default                 => '/etc/sysconfig/softwareAutoInstall'
    }
    $configfile_mode = $::operatingsystem ? {
        default => '0600',
    }
    $configfile_owner = $::operatingsystem ? {
        default => 'root',
    }
    $configfile_group = $::operatingsystem ? {
        default => 'root',
    }


}

