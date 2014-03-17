
class appdeploy::deps::mysql {
  include mysql::client
  ensure_packages(['libmysqlclient-dev'])
}
