define nginx::site (
  $server_name,
  $root,
  $root_owner = undef,
  $root_group = undef,
  $index      = "index.html index.htm",
  $try_files  = '$uri $uri/ $uri.html =404'
) {

  file {
    "Nginx root directory for site $name":
      path    => $root,
      ensure  => directory,
      require => File["Nginx default www directory"],
      owner   => $root_owner,
      group   => $root_group;

    "Nginx configuration file for site $name":
      path    => "/etc/nginx/conf.d/$name.site.conf",
      content => template("nginx/site.conf.erb"),
      require => [
        File["Nginx root directory for site $name"],
        Package["nginx"]
      ],
      notify  => Service["nginx"];
  }

}