# File::      <tt>mydef.pp</tt>
# Author::    M. Schmitt (maxime.schmitt@ext.uni.lu)
# Copyright:: Copyright (c) 2014 M. Schmitt
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# = Defines: softwareAutoInstall::mydef
#
# rtfm
#
# == Pre-requisites
#
# * The class 'softwareAutoInstall' should have been instanciated
#
# == Parameters:
#
# [*ensure*]
#   default to 'present', can be 'absent'.
#   Default: 'present'
#
# [*content*]
#  Specify the contents of the mydef entry as a string. Newlines, tabs,
#  and spaces can be specified using the escaped syntax (e.g., \n for a newline)
#
# [*source*]
#  Copy a file as the content of the mydef entry.
#  Uses checksum to determine when a file should be copied.
#  Valid values are either fully qualified paths to files, or URIs. Currently
#  supported URI types are puppet and file.
#  In neither the 'source' or 'content' parameter is specified, then the
#  following parameters can be used to set the console entry.
#
# == Sample usage:
#
#     include "softwareAutoInstall"
#
# You can then add a mydef specification as follows:
#
#      softwareAutoInstall::mydef {
#
#      }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define softwareAutoInstall::mydef(
    $ensure         = 'present',
    $content        = '',
    $source         = ''
)
{
    include softwareAutoInstall::params

    # $name is provided at define invocation
    $basename = $name

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("softwareAutoInstall::mydef 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    if ($softwareAutoInstall::ensure != $ensure) {
        if ($softwareAutoInstall::ensure != 'present') {
            fail("Cannot configure a softwareAutoInstall '${basename}' as softwareAutoInstall::ensure is NOT set to present (but ${softwareAutoInstall::ensure})")
        }
    }

    # if content is passed, use that, else if source is passed use that
    $real_content = $content ? {
        '' => $source ? {
            ''      => template('softwareAutoInstall/softwareAutoInstall_entry.erb'),
            default => ''
        },
        default => $content
    }
    $real_source = $source ? {
        '' => '',
        default => $content ? {
            ''      => $source,
            default => ''
        }
    }

    # concat::fragment { "${softwareAutoInstall::params::configfile}_${basename}":
    #     ensure  => "${ensure}",
    #     target  => "${softwareAutoInstall::params::configfile}",
    #     content => $real_content,
    #     source  => $real_source,
    #     order   => '50',
    # }

    # case $ensure {
    #     present: {

    #     }
    #     absent: {

    #     }
    #     disabled: {

    #     }
    #     default: { err ( "Unknown ensure value: '${ensure}'" ) }
    # }

}



