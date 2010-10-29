class munin::all {
  include munin
  include munin::read-only
  include munin-node
  include munin::defaults
  include munin::manifests
}

class munin {
  package { munin: }
  
  file { "/etc/munin/munin.conf":
    content => template("box/munin/munin.conf"),
    require => Package[munin]
  }

  apache::confd { munin: 
    source => "puppet:///box/munin/apache.conf"
  }

  define plugin($script = '', $config = false) {
    $real_script = $script ? {
      '' => $name,
      default => $script
    }
    file { "/etc/munin/plugins.model/$name":
      ensure => "/usr/share/munin/plugins/$real_script"
    }

    if $config {
      file { "/etc/munin/plugin-conf.d/$name":
        content => "[${name}]\n$config\n",
        require => Package["munin-node"]
      }
    }
  }
}

class munin::read-only {
  readonly::mount_tmpfs { ["/var/lib/munin","/var/www/munin"]: }

  file { "/var/log.model/munin": 
    ensure => directory, 
    owner => munin, 
    group => adm,
    require => Package[munin]
  }
  file { "/etc/munin/plugins.model": 
    ensure => directory
  }
  file { "/etc/munin/plugins": 
    ensure => "/var/etc/munin/plugins"
  }
}

class munin::defaults {
  munin::plugin { [ cpu, iostat, load, memory, netstat, irqstats, interrupts ]: }

  munin::plugin { df: 
    config => "env.exclude = rootfs squashfs tmpfs"
  }

  munin::plugin { if_eth0: script => if_, require => Package[ethtool] }
  munin::plugin { if_err_eth0: script => if_err_, require => Package[ethtool] }
  package { ethtool: }
}

class munin-node {
  package { "munin-node": }

  file { "/etc/munin/munin-node.conf":
    content => template("box/munin/munin-node.conf"),
    require => Package["munin-node"]
  }
}

class munin::manifests {
  file { "/etc/puppet/manifests/classes/munin.pp":
    source => "puppet:///box/munin/manifest.pp"
  }
}
