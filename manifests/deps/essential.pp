
class appdeploy::deps::essential {
  ensure_packages([
    'git',
    'unzip',
    'build-essential',
  ])
}
