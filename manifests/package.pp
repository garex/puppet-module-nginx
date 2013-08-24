class nginx::package {

  # Here we can then break packages by distro
  # See https://github.com/jfryman/puppet-nginx/blob/master/manifests/package.pp
  if ! defined(Package['nginx']) {
    package {'nginx':
      ensure => installed
    }
  }

}
