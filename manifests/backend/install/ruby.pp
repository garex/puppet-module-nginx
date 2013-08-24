class nginx::backend::install::ruby {

  $thin = "$(gem env gemdir)/bin/thin"

  package {'Ruby gems provider':
    name        => 'rubygems'
  }

  package {'Ruby backend service':
    require     => Package['Ruby gems provider'],
    name        => 'thin',
    provider    => 'gem',
  }

  exec {'Making thin bin visible':
    require   => Package['Ruby backend service'],
    command   => "ln --symbolic ${thin} /usr/bin/thin",
    creates   => '/usr/bin/thin',
  }

  if ($::osfamily == Debian) {
    $persistent_service = '/usr/sbin/update-rc.d -f thin defaults;'
  } else {
    $persistent_service = ''
  }

  exec {'Install ruby backend service':
    require     => Exec['Making thin bin visible'],
    creates     => '/etc/thin',
    command     => "thin install; ${persistent_service}",
  }

  file {'Ruby backend config directory should be fresh':
      ensure    => directory,
      require   => Exec['Install ruby backend service'],
      recurse   => true,
      purge     => true,
      path      => '/etc/thin',
  }

  service {'thin':
    ensure      => running,
    hasrestart  => true,
    enable      => true,
    require     => Exec['Install ruby backend service'],
  }

}