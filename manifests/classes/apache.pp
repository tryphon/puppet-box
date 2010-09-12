class apache {
  package { apache2-mpm-worker:
    alias => apache
  }

  file { "/etc/apache2/sites-available/default":
    source => "$source_base/files/apache/default",
    require => Package[apache]
  }

  file { "/var/www": ensure => directory, require => Package[apache] }

  file { "/var/log.model/apache2": 
    ensure => directory, 
    owner => root, 
    group => adm
  }
}

class apache::passenger {
  include apt::backport

  apt::source::pin { [libapache2-mod-passenger, librack-ruby, "librack-ruby1.8"]:
    source => "lenny-backports"
  }

  package { libapache2-mod-passenger: 
    require => Apt::Source[lenny-backports]
  }
}

class apache::dnssd {
  package { libapache2-mod-dnssd: }
  apache::module { mod-dnssd: config => true }
}

class apache::proxy::http {

  apache::module { proxy: config => true }
  apache::module { proxy_http: }

}
