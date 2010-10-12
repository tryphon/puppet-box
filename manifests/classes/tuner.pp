class tuner {
  package { fmtools: }

  file { "/etc/fm/fm.conf":
    ensure => "/var/etc/fm/fm.conf",
    require => File["/etc/fm"]
  }

  file { "/lib/firmware/dvb-fe-tda10046.fw":
    source => "puppet:///box/tuner/dvb-fe-tda10046.fw",
    mode => 644
  }

	file { "/etc/fm":
    ensure => directory
  }

  file { "/etc/default/fm":
    source => "puppet:///box/tuner/fm.default",
    mode => 755
  }

  exec { "update-rc.d fm defaults":
    require => File["/etc/init.d/fm"],
    creates => "/etc/rc0.d/K20fm"
  }

  file { "/etc/init.d/fm":
    source => "puppet:///box/tuner/fm.init",
    require => File["/etc/default/fm"],
    mode => 755
  }
}
