class nginx::config {

  $etc = "/etc/nginx"

  File {
    owner       => "root",
    group       => "root",
    mode        => "0644",
  }

  file {
    "Nginx config":
      require   => Package["nginx"],
      path      => "$etc/nginx.conf",
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
