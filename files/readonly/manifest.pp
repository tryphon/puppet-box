exec { "copy-var-model":
  creates => "/var/log/dmesg",
  command => "cp -a /var/log.model/* /var/log/",
  tag => boot
}

file { "/var/etc/default":
  ensure => directory,
  tag => boot
}
