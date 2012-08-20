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

    "Nginx default www directory":
      owner     => "root",
      group     => "root",
      path      => "/var/www",
      ensure    => directory;

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

  $config_directory = "/etc/nginx/conf.d"
  exec {"Nginx config purge":
    command     => "rm -f $config_directory/*",
    onlyif      => "test $(ls $config_directory | wc -l) > 0",
  }

}
