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

  include apache::steto
}

class apache::steto {
  steto::conf { apache: 
    source => "puppet:///box/apache/steto.rb"
  }
}

class apache::passenger {
  include apt::backport

  if $debian::lenny {
    apt::source::pin { [libapache2-mod-passenger, librack-ruby, "librack-ruby1.8"]:
      source => "lenny-backports",
      before => Package[libapache2-mod-passenger]
    }
  }
  package { libapache2-mod-passenger: }
}

class apache::dnssd {
  package { libapache2-mod-dnssd: }
  apache::module { mod-dnssd: config => true }
}

class apache::proxy::http {

  apache::module { proxy: config => true }
  apache::module { proxy_http: }

}

class apache::rewrite {
  apache::module { rewrite: }
}

class apache::syslog {
  exec { "add-www-data-user-to-adm-group":
    command => "adduser www-data adm",
    unless => "grep '^adm:.*www-data' /etc/group",
    require => Package[apache]
  }
}

class apache::xsendfile {
  $release = $debian::release ? {
    lenny => "0.12-1~bpo50+1",
    squeeze => "0.12-1~bpo60+2",
    default => "latest"
  }

  package { libapache2-mod-xsendfile: 
    require => Package[apache],
    ensure => "$release"
  }

  if $debian::lenny {
    apt::source::pin { libapache2-mod-xsendfile:
      source => "lenny-backports",
      before => Package[libapache2-mod-xsendfile]
    }
  }
}
