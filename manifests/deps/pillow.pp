
class appdeploy::deps::pillow {

  require puias

  case $osfamily {
    'RedHat': { ensure_packages(['libjpeg-turbo-devel', 'zlib-devel', 'freetype-devel']) }
    'Debian': { ensure_packages(['libjpeg-dev', 'zlib1g-dev', 'libfreetype6-dev']) }
  }
}
