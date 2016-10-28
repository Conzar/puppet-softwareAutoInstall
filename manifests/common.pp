# ------------------------------------------------------------------------------
# = Class: software_auto_install::common
#
# Base class to be inherited by the other software_auto_install classes
#
# Note: respect the Naming standard provided
# here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
#
class software_auto_install::common {
  require easybuild
  # Load the variables used in this module.
  # Check the software_auto_install::params.pp file
  require software_auto_install::params

  $install_dir = $software_auto_install::params::install_dir
  $python      = $software_auto_install::params::python_path
  $softwares   = $software_auto_install::softwares

  Exec { path => $software_auto_install::params::path }

  if $software_auto_install::ensure == 'present' {

    package { $software_auto_install::params::py_yaml:
      ensure => installed,
    }

    file {$install_dir:
      ensure => directory,
      require => Package[ $software_auto_install::params::py_yaml ],
    }

    file { 'install.py':
      ensure  => present,
      path    => "${install_dir}/install.py",
      owner   => 'sw',
      mode    => '0755',
      source  => 'puppet:///modules/software_auto_install/install.py',
      require => File[$install_dir],
    }

    file { 'softwares.yaml':
      ensure  => present,
      path    => "${install_dir}/softwares.yaml",
      owner   => 'sw',
      mode    => '0755',
      #source  => 'puppet:///modules/software_auto_install/softwares.yaml',
      content => template('software_auto_install/softwares.yaml.erb'),
      require => File['install.py'],
    }

    file { 'variables.sh':
      ensure  => present,
      path    => "${install_dir}/variables.sh",
      owner   => 'sw',
      mode    => '0755',
      source  => [
        'puppet:///modules/software_auto_install/variables.sh',
        '/etc/profile.d/easybuild.sh'
      ],
      require => File['softwares.yaml'],
    }


    # only run install if something has changed
    exec { 'install':
      user        => 'sw',
      command     => "${python} install.py ${software_auto_install::branch}\
 ${software_auto_install::easybuild_version}",
      umask       => '022',
      cwd         => $install_dir,
      environment => 'HOME=/home/sw',
      refreshonly => true,
      subscribe   => File[ 'install.py','softwares.yaml', 'variables.sh' ],
    }
  }
}