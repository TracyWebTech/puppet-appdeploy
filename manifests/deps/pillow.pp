
class appdeploy::deps::pillow {
  case $osfamily {
    'RedHat': { ensure_packages(['libjpeg-devel', 'zlib-devel', 'freetype-devel']) }
    'Debian': { ensure_packages(['libjpeg-dev', 'zlib1g-dev', 'libfreetype6-dev']) }
  }
}
