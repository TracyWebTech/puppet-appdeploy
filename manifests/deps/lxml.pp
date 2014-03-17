
class appdeploy::deps::lxml {
  ensure_packages([
    'libxml2-dev',
    'libxslt1-dev',
  ])
}
