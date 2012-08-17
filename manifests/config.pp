class nginx::config {

  file {
    "Nginx config":
      require   => Package["nginx"],
      owner     => "root",
      group     => "root",
      mode      => "0644",
      path      => "/etc/nginx/nginx.conf",
      notify    => Service["nginx"],
      content   => template("nginx/nginx.conf.erb");

    "Nginx sites enabled":
      path      => "/etc/nginx/sites-enabled",
      recurse   => true,
      force     => true,
      ensure    => absent;

    "Nginx sites available":
      path      => "/etc/nginx/sites-available",
      recurse   => true,
      force     => true,
      ensure    => absent;
  }

}
