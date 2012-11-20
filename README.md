# Puppet module for nginx install and manage

Adds nginx with sites support and independent php/ruby backends per site

## Description

Allows us to have:

 * nginx
 * independend sites
 * and independent backends (currently ruby and php)
 * *easily* extend to other backends
 * conigure php backend (systemwide)
 * simplest proxies
 * redirects from aliases (like www.site.com to site.com)
 * logs by site`s host name instead of default common logs (access.log and error.log)

It works on one simple principle:

 * in nginx we have "include conf.d/*.site.conf;"
 * in site we have few includes like "include "conf.d/<%= name %>.*.before.conf";"

Same principle is in php fpm and ruby's thin configuration. And good puppet keeps our dynamically generated config directory always actual by "recurse => true, purge => true" of the file's parameters.

## Usage

### Install nginx

Add this to your main module:

```ruby
  class {"nginx":
    user                => "www-data",
    worker_processes    => 1,
    worker_connections  => 1024,
    worker_rlimit_nofile=> 8192,
    gzip                => false
  }
```

Here we show all values, but they are already in defaults, so you can do it in less code as:

```ruby
  class {"nginx":
  }
```
Or in such way :)

```ruby
  class {"nginx": }
```

### Add site

By "site" we understand here "virtual host" in terms of apache or in terms of nginx it's a "server".

Title "Our site name" should be unique as it's some sort of id between other sites and between site and it's backends.

```ruby
  nginx::site {"Our site name":
    server_name => "our.site.com",
    redirect_from_aliases => "www.our.site.com",
    root        => "/var/www/our.site.com",
    root_owner  => "www-data",
    root_group  => "www-data",
    index       => "index.html index.htm",
    try_files   => '$uri $uri/ $uri.html =404',
    is_default  => true,
    is_independent_logs => true,
    custom_inside => "puppet:///modules/your-module/path-to-file.conf"
  }
```
Most params here are named same as in nginx config. It will help you to expand easily by adding new params and also to search in nginx wiki by their names.
*Abstraction here is just evil.*

**custom_inside** param is a method to pass your own nginx config inside. It's a puppet path to file in some of your modules.

**redirect_from_aliases** param is for redirecting from secondary domains (aliases) to the main domain with persistent code.

**is_independent_logs** param gives us individual access and error logs for site.

**Note** Single quotes around try_files are for this: in double quotes puppet will try to expand $uri variable and become sad.

### Enable some site`s param globally

Imagine, that we want independent logs for all sites by default -- we can use puppet`s defaults:

```ruby
  Nginx::Site {
    is_independent_logs => true,
  }
```

Same is true for other params and classes.

### Add backend to the site

So now we want to add backend to our site?

For ruby it will be:

```ruby
  nginx::backend::ruby {"Our site name":
    root        => "/usr/local/lib/redmine",
    port        => 8000,
    address     => '127.0.0.1',
    servers     => 3,
    is_welcome  => false,
    try_files   => '$uri $uri/ $uri/index.html @rubybackend'
  }
```

And for our lovely php:

```ruby
  nginx::backend::php {"Our site name":
    port        => 9000,
    try_files   => '$uri $uri/ $uri/index.html /index.php?url=$uri&$args'
  }
```

When adding backends, please watch for your port ranges -- they should not intersects. In ruby backend (thin web-server) it will create by default 3 servers on ports 8000, 8001 & 8002.

**Note.** Pls remember to use same title as for site: "Our site name".

### Configure PHP backend

```ruby
    class {"nginx::backend::config::php":
      display_errors      => "On",
      error_reporting     => "E_ALL & ~E_NOTICE & ~E_DEPRECATED & ~E_STRICT",
      expose_php          => "Off",
      html_errors         => "On",
      memory_limit        => "32M",
      short_open_tag      => "yes",
      date__timezone      => "Antarctica/Vostok",  # <-- Here we set date.timezone key
    }
```

**Note.** Dots in config keys are replaced by two underscores. Anyway if you have
IDE or some kind of code completeion -- it shouldn't be a problem as all possible
(or just many of them) keys are incorporated in *nginx::backend::config::php* class.

### Add proxy to some backend

```ruby
  nginx::proxy {"Frontend to backend":
    server_name   => "front.end",
    upstream_name => "http://back.end"
  }
```
Current version of proxy is simplest of possible -- just two directives, but it will work.

## GOODTODO

* Add more unversal connection between site & backend. Now we can't have only 1-to-1 connection of site and backend, as puppet will report duplication
* Add more backends for different languages
* Add more backends for concrete language. For example in ruby we can have mogrel, passenger (standalone here only) and another
* Add more nginx/site config params, but leave most good defaults
* Impruv mai inglish hia :)