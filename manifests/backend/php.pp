define nginx::backend::php (
  $port = 9000
) {

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