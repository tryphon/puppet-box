class pige::base {
  user { pige:
    uid => 2030,
    groups => [audio],
  }

  file { [
    "/usr/share/pigecontrol",
    "/usr/share/pigecontrol/tasks",
    "/usr/share/pigecontrol/bin"
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
}

class pige::go-broadcast {
  include ::go-broadcast

  file { "/etc/puppet/templates/go-broadcast.default":
    source => ['puppet:///files/pige/go-broadcast.default.erb', 'puppet:///box/pige/go-broadcast.default.erb']
  }
  file { "/etc/default/go-broadcast":
    ensure => "/var/etc/default/go-broadcast"
  }
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

  file { "/usr/share/pigecontrol/tasks/pige.rake":
    source => "puppet:///box/pige/pige.rake"
  }
  include sox

  file { "/usr/share/pigecontrol/bin/pige-cron":
    source => "puppet:///box/pige/pige-cron",
    mode => 755
  }

  file { "/etc/cron.d/pige":
    source => "puppet:///box/pige/pige.cron.d",
    require => Package[cron],
    # It should be default .. but :
    # File found in 664 with this message from cron :
    # INSECURE MODE (group/other writable) (/etc/cron.d/pige)
    mode => 644
  }
}
