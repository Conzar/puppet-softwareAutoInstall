# File::      <tt>params.pp</tt>
# Author::    M. Schmitt (maxime.schmitt@ext.uni.lu)
# Copyright:: Copyright (c) 2014 M. Schmitt
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# = Class: software_auto_install::params
#
# In this class are defined as variables values that are used in other
# software_auto_install classes.
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
class software_auto_install::params {

  ######## DEFAULTS FOR VARIABLES USERS CAN SET ##########################
  # (Here are set the defaults, provide your custom variables externally)
  # (The default used is in the line with '')
  ###########################################

  # ensure the presence (or absence) of software_auto_install
  $ensure = present

  # The Protocol used. Used by monitor and firewall class. Default is 'tcp'
  $protocl = 'tcp'

  # The port number. Used by monitor and firewall class. The default is 22.
  $port = '22'

  # example of an array variable
  $array_variable = []

  #### MODULE INTERNAL VARIABLES  #########
  # (Modify to adapt to unsupported OSes)
  #######################################
  # software_auto_install packages
  $packagename = $::osfamily ? {
      default => 'software_auto_install',
  }

  $path = $::osfamily ? {
    'redhat' => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/',
    '/usr/share/lmod/lmod/libexec/' ],
    'debian' => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
  }

  $moduleSource = $::osfamily ? {
    'redhat' => '/usr/share/lmod/lmod/init/profile',
    'debian' => '/usr/share/?odules/init/bash',
  }

  $py_yaml = $::osfamily ? {
    'redhat' => 'PyYAML',
    'debian' => 'python-yaml',
  }

  # Log directory
  $logdir = $::osfamily ? {
      default => '/var/log/software_auto_install'
  }
  $logdir_mode = $::osfamily ? {
      default => '750',
  }
  $logdir_owner = $::osfamily ? {
      default => 'root',
  }
  $logdir_group = $::osfamily ? {
      default => 'adm',
  }

  # software_auto_install associated services
  $servicename = $::osfamily ? {
      'debian' => 'software_auto_install',
      default  => 'software_auto_install'
  }
  # used for pattern in a service ressource
  $processname = $::osfamily ? {
      'debian' => 'software_auto_install',
      default  => 'software_auto_install'
  }
  $hasstatus = $::osfamily ? {
      'debian' => false,
      'redhat' => true,
      default  => true,
  }
  $hasrestart = $::osfamily ? {
      default => true,
  }

  $configfile = $::osfamily ? {
      default => '/etc/software_auto_install.conf',
  }
  $configfile_init = $::osfamily ? {
      'debian' => '/etc/default/software_auto_install',
      default  => '/etc/sysconfig/software_auto_install'
  }
  $configfile_mode = $::osfamily ? {
      default => '0600',
  }
  $configfile_owner = $::osfamily ? {
      default => 'root',
  }
  $configfile_group = $::osfamily ? {
      default => 'root',
  }

  $install_dir = '/opt/easybuild'
  $python_path = '/usr/bin/python'
  $softwares   = {
    'core'         => ['GCC-4.8.1.eb', 'GCC-4.9.1.eb'],
    'experimental' => ['GCC-4.8.2.eb'],
  }

  case $::osfamily {
    'debian':  { }
    'redhat':  { }
    default: {
      fail("Module ${::module_name} is not supported on ${::osfamily}")
    }
  }
}