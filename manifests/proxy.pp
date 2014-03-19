
define appdeploy::proxy (
  $user,
  $hosts,
  $upstream_ip = '127.0.0.1',
  $upstream_port = 8000,
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
    ssl    => true,
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
