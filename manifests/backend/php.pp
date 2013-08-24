define nginx::backend::php (
  $port             = 9000,
  $try_files        = '$uri $uri/ $uri/index.html /index.php?url=$uri&$args',
  $pool_user        = 'www-data',
  $pool_group       = 'www-data',
  $pm_max_requests  = 0,
  $rlimit_files     = undef,
  $variables        = []
) {

  include nginx::backend::install::php

  File {
    require => [
      File["Nginx root directory for site ${name}"],
      Package['nginx']
    ],
    notify  => [Service['nginx'], Service['php5-fpm']]
  }

  file {
    "PHP FPM backend config for ${name}":
      path    => "/etc/php5/fpm/pool.d/pool${port}.conf",
      content => template('nginx/backend.php.fpm.pool.conf.erb');

    "Nginx php backend before for site ${name}":
      path    => "/etc/nginx/conf.d/${name}.backend.php.before.conf",
      content => template('nginx/backend.php.before.conf.erb');

    "Nginx php backend inside for site ${name}":
      path    => "/etc/nginx/conf.d/${name}.backend.php.inside.conf",
      content => template('nginx/backend.php.inside.conf.erb');
  }

}