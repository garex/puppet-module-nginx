class nginx::backend::install::php {

  package {"PHP commons":
    name    => ["php5-cli", "php5-common", "php5-suhosin"],
    ensure  => installed,
  }

  if ($::operatingsystem == debian) {
    exec {"Fix FPM sources":
      onlyif  => "test ! $(grep packages.dotdeb.org /etc/apt/sources.list)",
      command => 'echo "deb http://packages.dotdeb.org stable all" >> /etc/apt/sources.list; wget -O - www.dotdeb.org/dotdeb.gpg | sudo apt-key add -; apt-get update;',
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