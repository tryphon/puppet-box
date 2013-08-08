file { "/var/etc/default/reverse-tunnel":
  content => template("reverse-tunnel.default"),
  tag => boot,
  notify => Service[reverse-tunnel]
}

service { reverse-tunnel:
  ensure => running,
  hasrestart => true
}
