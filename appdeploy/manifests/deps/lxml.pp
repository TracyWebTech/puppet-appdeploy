
class appdeploy::deps::lxml {
  case $::osfamily {

    'Redhat': {
      ensure_packages(['libxml2-devel', 'libxslt-devel'])
    }

    'Debian': {
      ensure_packages(['libxml2-dev', 'libxslt1-dev'])
    }

  }
}
