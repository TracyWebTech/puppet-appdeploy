
class appdeploy::deps::pillow {
  ensure_packages([
    # req by pillow
    'libjpeg-dev',
    'zlib1g-dev',
    'libfreetype6-dev',
  ])
}
