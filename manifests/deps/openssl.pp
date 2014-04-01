class appdeploy::deps::openssl {
  ensure_packages([
    'libssl-dev',
    'libffi-dev',
  ])
}
