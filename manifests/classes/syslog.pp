class syslog {
  package { rsyslog: }

  file { "/etc/rsyslog.conf":
    source => "puppet:///box/syslog/rsyslog.conf",
    require => Package[rsyslog]
  }

}

class rsyslog::module::file {
  file { "/etc/rsyslog.d/00imfile.conf":
    content => '$ModLoad imfile'
  }
}
