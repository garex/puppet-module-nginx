define nginx::site (
  $server_name,
  $root,
  $root_owner     = undef,
  $root_group     = undef,
  $index          = "index.html index.htm",
  $try_files      = '$uri $uri/ $uri.html =404',
  $custom_inside  = undef
) {

  file {
     $root:
      ensure  => directory,
      require => File["Nginx default www directory"],
      owner   => $root_owner,
      group   => $root_group;

    "Nginx root directory for site $name":
      require => File[$root],
      ensure  => "present",
      path    => "/tmp/puppet-module-nginx-site-workaround-for-bug-4867-$name";

    "Nginx configuration file for site $name":
      path    => "/etc/nginx/conf.d/$name.site.conf",
      content => template("nginx/site.conf.erb"),
      require => [
        File["Nginx root directory for site $name"],
        Package["nginx"]
      ],
      notify  => Service["nginx"];
  }

  if $custom_inside {
    file {"Nginx custom configuration file for site $name":
      ensure  => "present",
      path    => "/etc/nginx/conf.d/$name.custom.inside.conf",
      source  => $custom_inside,
      require => File["Nginx configuration file for site $name"],
      notify  => Service["nginx"];
    }
  }

}