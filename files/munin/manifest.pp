service { "munin-node":
  ensure => running,
  hasrestart => true
}

file { ["/var/etc/munin/", "/var/etc/munin/plugins"]:
  ensure => directory,
  tag => boot
}

exec { "copy-munin-model":
  command => "cp -a /etc/munin/plugins.model/* /etc/munin/plugins/",
  tag => boot,
  require => File["/var/etc/munin/plugins"],
  notify => Service["munin-node"]
}
