class network {
  include network::base
  include network::dhcp::readonly
  include network::ifplugd
  include network::hostname
  include network::resolvconf
  include network::resolvconf::readonly
  include network::wifi
}

class network::base {
  package { [netbase, ifupdown, net-tools]: } 
}

class network::dhcp {
  package { dhcp3-client: }
}

class network::dhcp::readonly {
  include network::dhcp
  include readonly::common

  file { "/etc/dhcp3/dhclient.conf":
    content => template("box/dhcp3/dhclient.conf"),
    require => Package["dhcp3-client"] 
  } 
  file { "/etc/dhcp3/dhclient-script":
    source => "puppet:///box/dhcp3/dhclient-script", 
    require => Package["dhcp3-client"] 
  } 

  readonly::mount_tmpfs { "/var/lib/dhcp3": }
}

class network::ifplugd {
  package { ifplugd: 
    before => Link["/etc/network/interfaces"]
  }
  file { "/etc/default/ifplugd":
    source => "puppet:///box/network/ifplugd.default", 
  }  
}

class network::resolvconf {
  package { resolvconf: }
}

class network::resolvconf::readonly {
  readonly::mount_tmpfs { "/etc/resolvconf/run": }
}

class network::hostname {
  file { "/etc/hostname": 
    content => "$box_name"
  }
  host { $box_name: ip => "127.0.1.1" }
}

class network::interfaces {
  link { "/etc/network/interfaces":
    target => "/var/etc/network/interfaces"
  }
}


class network::wifi {
  package { wpasupplicant: }

  file { "/etc/wpa_supplicant/wpa_cupplicant.conf":
    mode => 644,
    content => template("box/wpa_supplicant/wpa_supplicant.conf"),
    require => Package["wpasupplicant"]
  }
}
