file { "/var/etc/box": 
  ensure => directory,
  tag => boot
}

file { "/var/etc/box/local.rb": 
  content => template("config-local.rb"),
  tag => boot
}

file { "/var/etc/box/auto_upgrade":
  ensure => $release_auto_upgrade ? {
    "true" => present,
    default => absent
  },
  tag => boot
}

