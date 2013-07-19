file { "/var/etc/fm/":
  ensure => directory,
  tag => boot
}

file { "/var/etc/fm/fm.conf":
  content => template("/etc/puppet/templates/fm.conf"),
  notify => Service[fm],
  tag => boot
}

service { fm:
  ensure => running,
  hasrestart => true
}
