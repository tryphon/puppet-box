class icecast2 {

  package { icecast2: }

  # Links to files managed by embedded puppet
  link { "/etc/icecast2/icecast.xml":
    target => "/var/etc/icecast2/icecast.xml",
    require => Package[icecast2]
  }
  link { "/etc/default/icecast2":
    target => "/var/etc/icecast2/icecast2.default",
    require => Package[icecast2]
  }

  file { "/etc/puppet/manifests/classes/icecast.pp":
    source => "puppet:///box/icecast/manifest.pp"
  }
  file { "/etc/puppet/templates/icecast.xml":
    source => ["puppet:///files/icecast/icecast.xml", "puppet:///box/icecast/icecast.xml"]
  }
  file { "/etc/puppet/templates/icecast2.default":
    source => "puppet:///box/icecast/icecast2.default"
  }
  file { "/usr/local/bin/icecast-password":
    source => "puppet:///box/icecast/icecast-password.sh"
  }

  file { "/var/log.model/icecast2": 
    ensure => directory, 
    owner => icecast2,
    require => Package[icecast2]
  }

  # Icecast is blocked when using pipes
  #
  # pipe { [ "/var/log.model/icecast2/error.log", "/var/log.model/icecast2/access.log" ]:
  #   owner => "icecast2",
  #   require => [Package[icecast2], File["/var/log.model/icecast2"]]
  # }

  # Rsyslog doesn't reopen log files rotated by Icecast
  #
  # include rsyslog::module::file
  # file { "/etc/rsyslog.d/icecast.conf":
  #   source => "puppet:///box/icecast/rsyslog.conf"
  # }
}
