file { "/srv/pige/records":
  ensure => directory,
  owner => pige,
  tag => boot,
  require => Exec["storage-mount-pige"]
}

exec { "/usr/local/sbin/pige-migrate-uid":
  require => File["/srv/pige/records"],
  tag => boot
}

file { "/var/etc/default/go-broadcast":
  content => template("go-broadcast.default"),
  tag => boot,
  notify => Service[go-broadcast]
}

service { go-broadcast:
  ensure => running,
  hasrestart => true
}
