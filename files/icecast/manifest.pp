$icecast_enabled = $icecast_source_password ? {
  "" => false,
  default => true
}

service { "icecast2":
  ensure => $icecast_enabled ? {
    true => running,
    false => stopped
  },
  stop => "/etc/init.d/icecast2 stop && sleep 5",
  start => "/etc/init.d/icecast2 start && sleep 5"
  # hasrestart => true
}

file { ["/var/etc/icecast2"]:
  ensure => directory,
  tag => boot
}

if $icecast_enabled {
  $icecast_relay_password = generate("/usr/local/bin/icecast-password", $icecast_source_password, "relay")
  $icecast_admin_password = generate("/usr/local/bin/icecast-password", $icecast_source_password, "admin")

  file { "/var/etc/icecast2/icecast.xml":
    content => template("/etc/puppet/templates/icecast.xml"),
    owner => icecast2,
    group => icecast,
    mode => 640,
    notify => Service[icecast2],
    tag => boot
  }
}

file { "/var/etc/icecast2/icecast2.default":
  content => template("/etc/puppet/templates/icecast2.default"),
  tag => boot,
  notify => Service[icecast2]
}
