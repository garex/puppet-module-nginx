class nginx::backend::install::php {

  # Set global defaults
  Exec {
    path => "/usr/bin:/usr/sbin/:/bin:/sbin"
  }

  package {"PHP commons":
    name    => ["php5-cli", "php5-common", "php5-suhosin"],
    ensure  => installed,
  }

  file {"PHP FPM pool config directory should be fresh":
      require => Package["PHP FPM and CGI"],
      recurse => true,
      purge   => true,
      path    => "/etc/php5/fpm/pool.d",
      ensure  => directory
  }

  if ($::osfamily == Debian) {
    exec {"Fix FPM sources":
      onlyif  => "test ! $(grep packages.dotdeb.org /etc/apt/sources.list.d/dotdeb.list)",
      command => "echo \"deb http://packages.dotdeb.org ${::lsbdistcodename} all\" >> /etc/apt/sources.list.d/dotdeb.list; wget -O - www.dotdeb.org/dotdeb.gpg | apt-key add -; apt-get update",
    }
  } else {
    exec {"Fix FPM sources":
      onlyif  => "test ! true",
      command => 'test',
    }
  }

  package {"PHP FPM and CGI":
    require => [Package["PHP commons"], Exec["Fix FPM sources"]],
    name    => ["php5-fpm", "php5-cgi"],
    ensure  => installed,
  }

  service {"php5-fpm":
    ensure      => running,
    hasstatus   => true,
    hasrestart  => true,
    enable      => true,
    require     => Package["PHP FPM and CGI"],
  }

}
