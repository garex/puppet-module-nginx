# Puppet module for nginx install and manage

Adds nginx with sites support and independent php/ruby backends per site

## Description

Allows us to have:

 * nginx
 * independend sites
 * and independent backends (currently ruby and php)
 * *easily* extend to other backends

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
    root        => "/var/www/our.site.com",
    root_owner  => "www-data",
    root_group  => "www-data",
    index       => "index.html index.htm",
    try_files   => '$uri $uri/ $uri.html =404'
  }
```
All params here are named same as in nginx config. It will help you to expand easily by adding new params and also to search in nginx wiki by their names.
*Abstraction here is just evil.*

**Note** Single quotes around try_files are for this: in double quotes puppet will try to expand $uri variable and become sad.

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

## GOODTODO

* Add more unversal connection between site & backend. Now we can't have only 1-to-1 connection of site and backend, as puppet will report duplication
* Add more backends for different languages
* Add more backends for concrete language. For example in ruby we can have mogrel, passenger (standalone here only) and another
* Add more nginx/site config params, but leave most good defaults
* Impruv mai inglish hia :)