class network {
  include network::base
  include network::dhcp::readonly
  include network::ifplugd
  include network::hostname
  include network::resolvconf
  include network::resolvconf::readonly

  steto::conf { "network":
    source => "puppet:///box/network/steto.rb"
  }

  file { "/etc/puppet/templates/network":
    ensure => directory
  }
}

class network::base {
  package { [netbase, net-tools]: }

  package { ifupdown:
    before => [Link["/etc/network/interfaces"], Link["/etc/network/run"]]
  }
}

class network::dhcp {
  package { dhcp3-client: }
}

class network::dhcp::readonly {
  include network::dhcp
  include readonly::common

  include debian
  if $debian::lenny {
    file { "/etc/dhcp3":
      ensure => directory
    }
    file { "/etc/dhcp3/dhclient.conf":
      content => template("box/dhcp/dhclient.conf.lenny"),
      require => Package["dhcp3-client"]
    }
    file { "/etc/dhcp3/dhclient-script":
      source => "puppet:///box/dhcp/dhclient-script.lenny",
      require => Package["dhcp3-client"]
    }
  } else {
    file { "/etc/dhcp/dhclient.conf":
      content => template("box/dhcp/dhclient.conf.squeeze"),
      require => Package["dhcp3-client"]
    }
  }

  if $debian::lenny {
    readonly::mount_tmpfs { "/var/lib/dhcp3": }
  } else {
    readonly::mount_tmpfs { "/var/lib/dhcp": }
  }
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
  file { "/etc/puppet/manifests/classes/network.pp":
    source => "puppet:///box/network/manifest.pp"
  }
  file { "/usr/local/sbin/puppet-restart-network":
    source => "puppet:///box/network/puppet-restart-network",
    mode => 755
  }
  link { "/etc/network/run":
    target => "/var/etc/network/run"
  }

  box::config::migration { 20130515104043_create_network_interfaces:
    source => "puppet:///box/network/20130515104043_create_network_interfaces.rb"
  }

}

class network::wifi {
  package { [wpasupplicant, firmware-ralink, wireless-tools]: }

  file { "/etc/puppet/manifests/classes/network-wifi.pp":
    source => "puppet:///box/network/manifest-wifi.pp"
  }
  file { "/etc/puppet/templates/network/wpa_supplicant.conf":
    source => "puppet:///box/network/wpa_supplicant.conf"
  }

  link { "/etc/wpa_supplicant/wpa_supplicant.conf":
    target => "/var/etc/wpa_supplicant/wpa_supplicant.conf",
    require => Package[wpasupplicant]
  }

  # update initramfs is always updated after puppet
  line { "rt2800usb-blacklist":
    file => "/etc/modprobe.d/blacklist.conf",
    line => "blacklist rt2800usb"
  }
}

class network::vlan {
  package { vlan: }
}

class network::iptables {
  package { iptables: }
}

class network::gateway {
  line { "sysctl-ip4-forward":
    line => "net.ipv4.ip_forward=1",
    file => "/etc/sysctl.conf"
  }
}

class network::dnsutils {
  package { dnsutils: }
}
