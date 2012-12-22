class darkice::common {
  include box::user

  file { "/etc/darkice/darkice.cfg":
    ensure => "/var/etc/darkice/darkice.cfg"
  }

  file { "/etc/darkice":
    ensure => directory
  }

  file { "/etc/init.d/darkice":
    source => "puppet:///box/darkice/darkice.init",
    require => File["/etc/default/darkice"],
    mode => 775
  }    
  exec { "update-rc.d darkice defaults":
    require => File["/etc/init.d/darkice"],
    creates => "/etc/rc0.d/K20darkice"
  }

  file { "/etc/default/darkice":
    source => "puppet:///box/darkice/darkice.default",
    require => User[boxuser]
  }

  file { "/usr/local/bin/darkice-safe":
    source => "puppet:///box/darkice/darkice-safe",
    require => Package[darkice],
    mode => 775
  }    

  file { "/etc/puppet/templates/darkice.cfg":
    source => "puppet:///files/darkice/darkice.cfg"
  }
  file { "/etc/puppet/manifests/classes/darkice.pp":
    source => "puppet:///box/darkice/manifest.pp"
  }
}

class darkice::full {
  include darkice::common
  include apt::multimedia
  include apt::tryphon

  package { darkice-full: 
    ensure => "1.2+svn506-1",
    alias => darkice,
    require => [Apt::Source[tryphon], Apt::Source[debian-multimedia]]
  }

  if $debian::lenny {
    apt::source::pin { [darkice-full, libaacplus1]:
      source => "tryphon",
      release => "lenny-backports",
      before => Package[darkice-full]
    }
  } 
}

class darkice {
  include darkice::common
  package { darkice: }
}
