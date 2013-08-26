class pige::base {
  user { pige:
    uid => 2030,
    groups => [audio],
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
}

class pige::go-broadcast {
  include ::go-broadcast

  file { "/etc/puppet/templates/go-broadcast.default":
    source => "puppet:///box/pige/go-broadcast.default.erb"
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
