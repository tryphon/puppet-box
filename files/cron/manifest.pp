file { "/var/etc/cron.d":
  ensure => directory,
  tag => boot
}

file { "/var/etc/cron.d/user-crons":
  content => template("user-crons"),
  tag => boot
}
