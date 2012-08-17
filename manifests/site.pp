define nginx::site (
  $server_name,
  $root,
  $root_owner = undef,
  $root_group = undef
) {

  file {
    "Nginx root directory for site $name":
      path    => $root,
      ensure  => directory,
      owner   => $root_owner,
      group   => $root_group;

    "Nginx configuration file for site $name":
      path    => "/etc/nginx/conf.d/$name.site.conf",
      content => template("nginx/nginx.site.conf.erb"),
      require => [
        File["Nginx root directory for site $name"],
        Exec["Nginx config purge"],
        Package["nginx"]
      ],
      notify  => Service["nginx"];
  }

}