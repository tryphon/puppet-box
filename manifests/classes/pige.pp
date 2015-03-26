class pige::base($web_application = "pigecontrol") {
  user { pige:
    uid => 2030,
    groups => [audio],
  }

  file { [
    "/usr/share/${web_application}",
    "/usr/share/${web_application}/tasks",
    "/usr/share/${web_application}/bin"
    ]:
    ensure => directory
  }

  file { "/usr/local/sbin/pige-migrate-uid":
    source => "puppet:///box/pige/pige-migrate-uid.sh",
    mode => 755
  }

  file { "/etc/puppet/manifests/classes/pige.pp":
    source => "puppet:///box/pige/manifest.pp"
  }

  include pige::go-broadcast
  include pige::gem
  include pige::cron
  include pige::storage
}

class pige::go-broadcast {
  include ::go-broadcast
}

class pige::gem {
  ruby::gem { pige:
    ensure => "0.0.3",
    require => Package[libtagc0-dev, libtag1-dev]
  }
  package { [libtagc0-dev, libtag1-dev]: }
}


class pige::steto {
  steto::conf { pige:
    source => "puppet:///box/pige/steto.rb"
  }
  include sox::ruby
  include pige::gem
}

class pige::cron {
  include ::cron # ::cron not supported by this puppet version
  package { rake: }

  file { "/usr/share/${pige::base::web_application}/tasks/pige.rake":
    source => "puppet:///box/pige/pige.rake"
  }
  include sox

  file { "/usr/share/${pige::base::web_application}/bin/pige-cron":
    source => "puppet:///box/pige/pige-cron",
    mode => 755
  }

  file { "/etc/cron.d/pige":
    content => "1,16,31,46 * * * *     pige   /usr/share/${pige::base::web_application}/bin/pige-cron\n",
    require => Package[cron],
    # It should be default .. but :
    # File found in 664 with this message from cron :
    # INSECURE MODE (group/other writable) (/etc/cron.d/pige)
    mode => 644
  }
}

class pige::storage {
  class { 'box::storage':
    storage_name => "pige",
    warning_threshold => 4096,
    critical_threshold => 2048,
  }
}
