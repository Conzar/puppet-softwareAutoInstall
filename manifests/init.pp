# File::      <tt>init.pp</tt>
# Author::    M. Schmitt (maxime.schmitt@ext.uni.lu)
# Copyright:: Copyright (c) 2014 M. Schmitt
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# = Class: software_auto_install
#
# rtfm
#
# == Parameters:
#
# $ensure::
#  Ensure the presence (or absence) of software_auto_install
#  *Default*: 'present'.
#
# == Actions:
#
# Install and configure software_auto_install
#
# == Requires:
#
# n/a
#
# == Sample Usage:
#
#     import software_auto_install
#
# You can then specialize the various aspects of the configuration,
# for instance:
#
#         class { 'software_auto_install':
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
class software_auto_install(
  $ensure            = $software_auto_install::params::ensure,
  $softwares         = $software_auto_install::params::softwares,
  $branch            = 'core',
  $easybuild_version = ''
) inherits software_auto_install::params {
    info ("Configuring software_auto_install (with ensure = ${ensure})")

  if ! ($ensure in [ 'present', 'absent' ]) {
    fail("software_auto_install 'ensure' parameter must be set to either\
 'absent' or 'present'")
  }

  class{'software_auto_install::common':}

}