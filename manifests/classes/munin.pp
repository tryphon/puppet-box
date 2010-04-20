class munin {
  package { munin: }
  
  file { "/etc/munin/munin.conf":
    content => template("box/munin/munin.conf"),
    require => Package[munin]
  }

}

class munin::readonly {
  include munin

  readonly::mount_tmpfs { ["/var/lib/munin","/var/www/munin"]: }

  file { "/var/log.model/munin": 
    ensure => directory, 
    owner => munin, 
    group => adm,
    require => Package[munin]
  }
    
}

class munin-node {
  package { "munin-node": }

  file { "/etc/munin/munin-node.conf":
    content => template("box/munin/munin-node.conf"),
    require => Package["munin-node"]
  }
}
