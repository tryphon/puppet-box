file { ["/var/etc/network", "/var/etc/network/run"]:
  ensure => directory,
  tag => boot
}

$network_interfaces=split($interfaces,",")

file { "/var/etc/network/interfaces":
  content => template("/etc/puppet/templates/interfaces"),
  notify => Exec["restart-networking"],
  tag => boot
}

exec { "restart-networking": 
  command => "/sbin/ifdown eth0 && /sbin/ifup eth0",
  refreshonly => true
}

file { "/var/etc/resolv.conf":
  ensure => present,
  tag => boot
}
