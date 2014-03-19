
define appdeploy::django (
  $user,
  $port = 8000,
  $environment = undef,
  $celery = false,
  $proxy = true,
  $proxy_hosts = [],
) {
  include supervisor

  include appdeploy::deps::l10n
  include appdeploy::deps::gevent
  include appdeploy::deps::python
  include appdeploy::deps::pillow
  include appdeploy::deps::essential

  Supervisor::App {
    directory   => "/home/$user/$title/src",
    user        => $user,
    environment => $environment,
  }

  $virtualenv_path = "/home/$user/.virtualenvs/$title"
  $manage_path = "$virtualenv_path/bin/python manage.py"

  supervisor::app { $title:
    command => "$virtualenv_path/bin/gunicorn $title.wsgi:application",
  }

  if $celery {
    supervisor::app { 'celeryd':
      command => "$manage_path celeryd -E",
    }

    supervisor::app { 'celerybeat':
      command => "$manage_path celerybeat",
    }

    supervisor::app { 'celerycam':
      command => "$manage_path celerycam",
    }

    supervisor::app { 'celeryflower':
      command => "$manage_path celery flower --address=0.0.0.0",
    }
  }

  if $proxy {
    appdeploy::proxy { $title:
      user          => $user,
      hosts         => $proxy_hosts,
      upstream_ip   => '127.0.0.1',
      upstream_port => $port,
    }
  }
}
