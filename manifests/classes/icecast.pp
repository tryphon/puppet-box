class icecast2 {

  package { icecast2: }

  # file { "/etc/icecast2/icecast.xml":
  #   source => "puppet://files/icecast2/icecast.xml",
  #   require => Package[icecast2],
  #   owner => icecast2,
  #   group => adm,
  #   mode => 640
  # }

  # file { "/etc/default/icecast2":
  #   source => "$source_base/files/icecast2/icecast2.default",
  #   require => Package[icecast2]
  # }

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
    source => "puppet:///box/icecast/icecast.xml"
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
}
