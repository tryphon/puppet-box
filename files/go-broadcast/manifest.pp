file { "/var/etc/default/go-broadcast":
  content => template("go-broadcast.default"),
  tag => boot,
  notify => Service[go-broadcast]
}

file { '/var/etc/go-broadcast':
  ensure => directory,
  tag => boot
}

file { '/var/etc/go-broadcast/config.json':
  ensure => present,
  content => '{}',
  replace => false,
  owner => boxdaemon,
  tag => boot
}

service { go-broadcast:
  ensure => running,
  hasrestart => true
}
