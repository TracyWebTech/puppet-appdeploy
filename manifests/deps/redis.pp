
class appdeploy::deps::redis {
  if ! defined(Class['redis']) {
    class { 'redis':
      manage_repo => true,
    }
  }
}
