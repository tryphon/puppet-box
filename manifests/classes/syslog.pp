class syslog {
  package { rsyslog: }

  file { "/etc/rsyslog.conf":
    source => "puppet:///box/syslog/rsyslog.conf",
    require => [Package[rsyslog], File["/usr/local/bin/flogrotate"]]
  }

  file { "/etc/logrotate.d/rsyslog":
    source => "puppet:///box/syslog/rsyslog.logrotate"
  }

  file { "/var/lib/logrotate":  
    ensure => directory
  }

  readonly::mount_tmpfs { "/var/lib/logrotate": }

  file { "/var/log.model/syslog": 
    ensure => present, 
    owner => root, 
    group => adm,
    mode => 640
  }

  file { "/usr/local/bin/flogrotate":
    source => "puppet:///box/syslog/flogrotate",
    mode => 755
  }

  file { "/etc/puppet/manifests/classes/syslog.pp":
    source => "puppet:///box/syslog/manifest.pp"
  }

  # Used to store config parts generated by puppet at runtime
  file { "/etc/rsyslog.d/runtime":
    ensure => directory,
    require => Package[rsyslog]
  }
  readonly::mount_tmpfs { "/etc/rsyslog.d/runtime": }

  include rsyslog::steto
}

class rsyslog::module::file {
  file { "/etc/rsyslog.d/00imfile.conf":
    content => '$ModLoad imfile',
    require => Package[rsyslog]
  }
}

class rsyslog::server {
  file { "/etc/rsyslog.d/udp-server.conf":
    content => "\$ModLoad imudp\n\$UDPServerRun 514\n",
    require => Package[rsyslog]
  }
}

class rsyslog::steto {
  steto::conf { syslog: 
    source => "puppet:///box/syslog/steto.rb"
  }
}
