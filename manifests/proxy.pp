
define appdeploy::proxy (
  $user,
  $hosts,
  $upstream_ip = '127.0.0.1',
  $upstream_port = 8001,
  $websocket = undef,
) {

  include nginx

  ensure_resource('nginx::resource::vhost', 'default', {
    server_name         => ['_'],
    index_files         => [],
    access_log          => '/dev/null',
    error_log           => '/dev/null',
    listen_options      => 'default_server',
    location_custom_cfg => {
      return => 444,
    },
  })

  nginx::resource::upstream { $title:
    ensure  => present,
    members => ["$upstream_ip:$upstream_port"],
  }

  nginx::resource::location { "@$title-app":
    ensure => present,
    vhost  => $title,
    proxy  => "http://$title",
    ssl    => true
  }

  nginx::resource::location { "private-media":
    ensure         => present,
    vhost          => $title,
    location       => '/media/private',
    location_alias => "/usr/share/nginx/$user/media/private/",
    location_custom_cfg_append => {
      add_header => "cache-control no-cache",
      internal   => "",
    },
  }

  if $websocket {
    nginx::resource::upstream { "$title-websocket":
      ensure  => present,
      members => ["$websocket"],
    }

    nginx::resource::location { "@$title-app-websocket":
      ensure   => present,
      vhost    => $title,
      proxy    => "http://$title-websocket",
      location => '/ws',
      location_custom_cfg_append => {
        proxy_http_version => "1.1",
        proxy_set_header   => {
          'Upgrade'    => '$http_upgrade',
          'Connection' => '"upgrade"',
        },
      }
    }
  }

  ensure_resource('file', ['/etc/nginx/ssl', "/etc/nginx/ssl/$title"], {
    ensure => directory,
    mode   => 0755,
    owner  => root,
  })

  openssl::certificate { "/etc/nginx/ssl/$title/$title.crt":
    country      => 'BR',
    state        => 'State',
    city         => 'City',
    organization => 'Company',
    common_name  => $hosts[0],
    require      => File["/etc/nginx/ssl/$title"],
  }

  nginx::resource::vhost { $title:
    ensure      => present,
    www_root    => "/usr/share/nginx/$user",
    index_files => [],
    try_files   => ['$uri', "@$title-app"],
    ssl         => true,
    ssl_cert    => "/etc/nginx/ssl/$title/$title.crt",
    ssl_key     => "/etc/nginx/ssl/$title/$title.key",
    server_name => $hosts,
    require     => Openssl::Certificate["/etc/nginx/ssl/$title/$title.crt"],
  }
}
