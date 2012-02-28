if $syslog_server == "" {
  $syslog_server = false
}

file { "/etc/rsyslog.d/runtime/server.conf":
  ensure => $syslog_server ? {
    false => absent,
    default => present
  },
  content => "*.*             @${syslog_server}\n",
  notify => Service[rsyslog]
}

service { rsyslog: 
  ensure => running
}
