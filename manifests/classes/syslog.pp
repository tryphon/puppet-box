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
}

class rsyslog::module::file {
  file { "/etc/rsyslog.d/00imfile.conf":
    content => '$ModLoad imfile',
    require => Package[rsyslog]
  }
}
