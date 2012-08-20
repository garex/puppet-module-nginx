define nginx::backend::php (
  $port       = 9000,
  $index      = "index.html index.htm index.php",
  $try_files  = '$uri $uri/ $uri/index.html /index.php?url=$uri&$args'
) {

  package {"PHP commons for $name":
    name    => ["php5-cli", "php5-common", "php5-suhosin"],
    ensure  => installed,
  }

  package {"PHP FPM and CGI for $name":
    require => Package["PHP commons for $name"],
    name    => ["php5-fpm", "php5-cgi"],
    ensure  => installed,
  }

  service {"PHP FPM service for $name":
    name        => "php5-fpm",
    ensure      => running,
    hasstatus   => true,
    hasrestart  => true,
    enable      => true,
    require     => Package["PHP FPM and CGI for $name"],
  }

  File {
    require => [
      File["Nginx root directory for site $name"],
      Exec["Nginx config purge"],
      Package["nginx"]
    ],
    notify  => Service["nginx"]
  }

  file {
    "Nginx php backend before for site $name":
      path    => "/etc/nginx/conf.d/$name.backend.php.before.conf",
      content => template("nginx/backend.php.before.conf.erb");

    "Nginx php backend inside for site $name":
      path    => "/etc/nginx/conf.d/$name.backend.php.inside.conf",
      content => template("nginx/backend.php.inside.conf.erb");
  }

}