
class appdeploy::deps::postgresql {
  include postgresql::client
  ensure_packages(['libpq-dev'])
}
