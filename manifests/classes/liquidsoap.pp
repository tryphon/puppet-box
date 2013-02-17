class liquidsoap {
  # TODO don't install recommended icecast2
  if $debian::lenny {
    include apt::backport
    package { liquidsoap: 
      ensure => "0.9.2-1~bpo50+3",
      require => [Apt::Source::Pin[liquidsoap], Package[sox]]
    }  
    apt::source::pin { "liquidsoap":
      source => "lenny-backports"
    }
  } else {
    package { liquidsoap: }
  }

  include sox
  package { [flac, faad, mplayer]: }

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

define liquidsoap::log() {
  pipe { "/var/log.model/liquidsoap/$name.log":
    owner => "liquidsoap",
    require => [Package[liquidsoap], File["/var/log.model/liquidsoap"]]
  }

  include rsyslog::module::file
  file { "/etc/rsyslog.d/liquidsoap-$name.conf":
    content => template("box/liquidsoap/rsyslog.conf"),
    require => Package[rsyslog]
  }
}
