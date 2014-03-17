
class appdeploy::deps::python {
  require pip

  ensure_packages(['python-dev'])

  package { 'virtualenvwrapper':
    ensure   => installed,
    provider => pip,
  }

  # links virtualenvwrapper to load automaticaly
  file { '/etc/bash_completion.d/virtualenvwrapper.sh':
    ensure => link,
    target => '/usr/local/bin/virtualenvwrapper.sh',
  }
}
