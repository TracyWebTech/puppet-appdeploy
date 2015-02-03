
define appdeploy::django (
  $user,
  $environment = undef,
  $celery = false,
  $proxy = true,
  $proxy_hosts = [],
  $directory = "/home/${user}/${title}/src",
  $vhost_cfg_append = undef,
  $gunicorn = {
    workers      => 'auto',
    worker_class => 'eventlet',
    loglevel     => 'error',
    bind         => '127.0.0.1:8001',
    errorlog     => "~/${title}.log",
  },

  # Deprecated params
  $ip = undef,
  $port = undef,
  $gunicorn_cfg = undef,
) {
  include supervisor

  include appdeploy::deps::l10n
  include appdeploy::deps::python
  include appdeploy::deps::pillow
  include appdeploy::deps::essential

  Supervisor::App {
    directory   => $directory,
    user        => $user,
    environment => $environment,
  }

  validate_hash($gunicorn)

  $virtualenv_path = "/home/${user}/.virtualenvs/${title}"
  $manage_path = "${virtualenv_path}/bin/python ${directory}/manage.py"

  $default_gunicorn_cfg_path = "/etc/gunicorn-${title}.conf.py"

  if $gunicorn_cfg {
    warning('Passing "gunicorn_cfg" to appdeploy::django is ' \
            'deprecated; please use the gunicorn parameter instead.')
    $gunicorn_cfg_path = $gunicorn_cfg

  } else {
    $gunicorn_cfg_path = $default_gunicorn_cfg_path

    file { "${title}-gunicorn-config":
      path    => $gunicorn_cfg_path,
      content => template('appdeploy/django/gunicorn.conf.py.erb'),
      before  => Supervisor::App[$title],
    }
  }

  if $ip or $port {
    # IP and Port should be set using $gunicorn hash map
    warning('Passing "ip" and/or "port" to appdeploy::django ' \
            'is deprecated; please use gunicorn["bind"] parameter instead.')
    $port_ = pick($port, '8001')
    $ip_ = pick($ip, '127.0.0.1')
    $app_cmd = "${virtualenv_path}/bin/gunicorn ${title}.wsgi:application " \
                "--bind=${ip_}:${port_} --config=${gunicorn_cfg_path}"
  } else {
    $app_cmd = "${virtualenv_path}/bin/gunicorn ${title}.wsgi:application " \
                "--config=${gunicorn_cfg_path}"
  }

  supervisor::app { $title:
    command => $app_cmd,
  }

  if $celery {
    supervisor::app { 'celery-worker':
      command => "${virtualenv_path}/bin/celery worker --events --app=${title}",
    }

    supervisor::app { 'celery-beat':
      command => "${virtualenv_path}/bin/celery beat --app=${title}",
    }
  }

  if $proxy {
    appdeploy::proxy { $title:
      user             => $user,
      hosts            => $proxy_hosts,
      upstream_ip      => $ip,
      upstream_port    => $port,
      vhost_cfg_append => $vhost_cfg_append,
    }
  }

  cron { 'clearsessions-new':
    command => "${manage_path} clearsessions",
    hour    => '3',
    minute  => '27',
    user    => $user,
  }

  cron { 'clearsessions':
    ensure  => absent,
    command => "${manage_path} clearsessions",
    hour    => '3',
    minute  => '27',
  }

}
