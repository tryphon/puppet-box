class syslog {
  package { rsyslog: }

  file { "/etc/rsyslog.conf":
    source => "puppet:///box/syslog/rsyslog.conf",
    require => Package[rsyslog]
  }

  file { "/etc/logrotate.d/rsyslog":
    source => "puppet:///box/syslog/rsyslog.logrotate"
  }

  file { "/var/lib/logrotate":  
    ensure => directory
  }

  readonly::mount_tmpfs { "/var/lib/logrotate": }

}

class rsyslog::module::file {
  file { "/etc/rsyslog.d/00imfile.conf":
    content => '$ModLoad imfile',
    require => Package[rsyslog]
  }
}
