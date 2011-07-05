class liquidsoap {
  include apt::backport

  # TODO don't install recommended icecast2
  package { liquidsoap: 
    ensure => "0.9.2-1~bpo50+3",
    require => Apt::Source::Pin[liquidsoap]
  }

  apt::source::pin { "liquidsoap":
    source => "lenny-backports"
  }

  exec { "add-liquidsoap-user-to-audio-group":
    command => "adduser liquidsoap audio",
    unless => "grep '^audio:.*liquidsoap' /etc/group",
    require => Package[liquidsoap]
  }
}

class liquidsoap::readonly {
  include readonly::common
  include liquidsoap

  file { "/var/log.model/liquidsoap":
    ensure => directory,
    owner => liquidsoap,
    require => Package[liquidsoap]
  }
  file { "/etc/init.d/liquidsoap":
    mode => 755,
    source => "puppet:///box/liquidsoap/liquidsoap.initd",
    require => Package[liquidsoap]
  }
}
