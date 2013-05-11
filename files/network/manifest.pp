file { ["/var/etc/network", "/var/etc/network/run"]:
  ensure => directory,
  tag => boot
}

file { "/var/etc/network/interfaces":
  content => template("/etc/puppet/templates/interfaces"),
  notify => Exec["restart-networking"],
  tag => boot
}

exec { "restart-networking": 
  # Puppet runs this command even if tag boot is not defined
  command => '/usr/local/sbin/puppet-restart-network',
  refreshonly => true
}

file { "/var/etc/resolv.conf":
  ensure => present,
  tag => boot
}
