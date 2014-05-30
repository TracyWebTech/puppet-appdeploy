
define appdeploy::django (
  $user,
  $ip = '127.0.0.1',
  $port = 8001,
  $environment = undef,
  $celery = false,
  $proxy = true,
  $proxy_hosts = [],
  $directory = "/home/$user/$title/src",
  $websocket = undef,
  $vhost_cfg_append = undef,
) {
  include supervisor

  include appdeploy::deps::l10n
  include appdeploy::deps::gevent
  include appdeploy::deps::python
  include appdeploy::deps::pillow
  include appdeploy::deps::essential

  Supervisor::App {
    directory   => $directory,
    user        => $user,
    environment => $environment,
  }

  $virtualenv_path = "/home/$user/.virtualenvs/$title"
  $manage_path = "$virtualenv_path/bin/python manage.py"

  supervisor::app { $title:
    command => "$virtualenv_path/bin/gunicorn $title.wsgi:application --bind=$ip:$port --worker-class=gevent --workers=3",
  }

  if $celery {
    supervisor::app { 'celery-worker':
      command => "$virtualenv_path/bin/celery worker --events --app=$title",
    }

    supervisor::app { 'celery-beat':
      command => "$virtualenv_path/bin/celery beat --app=$title",
    }
  }

  if $proxy {
    appdeploy::proxy { $title:
      user              => $user,
      hosts             => $proxy_hosts,
      upstream_ip       => $ip,
      upstream_port     => $port,
      websocket         => $websocket,
      vhost_cfg_append  => $vhost_cfg_append,
    }
  }
}
