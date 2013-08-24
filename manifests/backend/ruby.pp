define nginx::backend::ruby (
  $root,
  $port       = 8000,
  $address    = '127.0.0.1',
  $servers    = 3,
  $is_welcome = false,
  $try_files  = '$uri $uri/ $uri/index.html @rubybackend'
) {

  include nginx::backend::install::ruby

  File {
    require => [
      File["Nginx root directory for site ${name}"],
      Package['nginx']
    ],
    notify  => [Service['nginx'], Service['thin']]
  }

  if $is_welcome {
    $test_welcome = "<h1>${name} (nginx + ruby backend)</h1>"
    file {"Ruby backend test file for site ${name}":
      replace   => false,
      path      => "${root}/config.ru",
      content   => template('nginx/backend.ruby.test.config.ru.erb')
    }
  }

  file {
    "Ruby backend config for ${name}":
      path    => "/etc/thin/${name}.yml",
      content => template('nginx/backend.ruby.thin.pool.yml.erb');

    "Nginx ruby backend before for site ${name}":
      path    => "/etc/nginx/conf.d/${name}.backend.ruby.before.conf",
      content => template('nginx/backend.ruby.before.conf.erb');

    "Nginx ruby backend inside for site ${name}":
      path    => "/etc/nginx/conf.d/${name}.backend.ruby.inside.conf",
      content => template('nginx/backend.ruby.inside.conf.erb');
  }

}