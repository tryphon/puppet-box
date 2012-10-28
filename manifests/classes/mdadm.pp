class mdadm {
  package { mdadm: }

  if $debian::squeeze {
    file { "/etc/init.d/mdadm-raid":
      source => "puppet:///box/mdadm/mdadm-raid.init.squeeze",
      require => Package[mdadm]
    }
  }
}
