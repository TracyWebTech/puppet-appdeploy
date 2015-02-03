class appdeploy::deps::openssl {
  case $::osfamily {
    'RedHat': { ensure_packages(['openssl-devel', 'libffi-devel']) }
    'Debian': { ensure_packages(['libssl-dev', 'libffi-dev']) }
  }
}
