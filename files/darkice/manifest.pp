file { "/var/etc/darkice/":
  ensure => directory,
  tag => boot
}

file { "/var/etc/darkice/darkice.cfg":
  content => template("/etc/puppet/templates/darkice.cfg"),
  notify => Service[darkice],
  tag => boot
}

service { darkice:
  ensure => running,
  hasrestart => true
}
