
define appdeploy::wsproxy (
  $vhost,
  $upstream_ip = '127.0.0.1',
  $upstream_port = '8080',
){
  nginx::resource::upstream { "$title-websocket":
    ensure  => present,
    members => ["$upstream_ip:$upstream_port"],
  }

  nginx::resource::location { "@$title-app-websocket":
    ensure   => present,
    vhost    => $vhost,
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
