class puppet {
  include apt::backport

  package { puppet: 
    ensure => "2.6.2-4~bpo50+1",
    require => [Apt::Source::Pin[puppet], Apt::Source::Pin[puppet-common]]
  }
  apt::source::pin { ["puppet","puppet-common"]:
    source => "lenny-backports"
  }

  # Fix support of START=no
  file { "/etc/init.d/puppet":
    source => "puppet:///box/puppet/puppet.init",
    mode => 755
  }

  readonly::mount_tmpfs { "/var/lib/puppet": }

  file { "/etc/init.d/puppet-boot":
    source => "puppet:///box/puppet/puppet-boot.init",
    mode => 755,
    require => File["/usr/local/sbin/launch-puppet"]
  }
  file { "/etc/puppet/manifests":
    ensure => directory,
    recurse => true,
    source => "$source_base/files/puppet/manifests"
  }

  file { "/boot/config.pp":
    source => ["$source_base/files/puppet/config.pp", "puppet:///box/puppet/config.pp"]
  }
  file { "/etc/puppet/manifests/config.pp":
    ensure => "/var/etc/puppet/manifests/config.pp"
  }

  file { "/etc/puppet/manifests/classes":
    ensure => directory
  }
  file { "/etc/puppet/manifests/classes/empty.pp":
    ensure => present
  }

  file { "/etc/puppet/templates":
    ensure => directory,
    recurse => true,
    source => "$source_base/files/puppet/templates"
  }
  file { "/etc/puppet/templates/interfaces":
    source => "puppet:///box/puppet/templates/interfaces"
  }

  file { "/etc/puppet/templates/wpa_supplicant.conf":
    source => "puppet:///box/puppet/templates/wpa_supplicant/wpa_supplicant.conf"
  }

  file { "/usr/local/sbin/launch-puppet":
    source => "puppet:///box/puppet/launch-puppet",
    mode => 755
  }
  file { "/usr/local/sbin/save-puppet-config":
    source => "puppet:///box/puppet/save-puppet-config",
    mode => 755
  }

  exec { "update-rc.d-puppet-boot":
    command => "update-rc.d puppet-boot start 38 S . stop 40 0 6 .",
    require => File["/etc/init.d/puppet-boot"],
    creates => "/etc/rcS.d/S38puppet-boot"
  }

  sudo::line { "www-data-launch-puppet":
    line => "www-data	ALL=(root) NOPASSWD: /usr/local/sbin/launch-puppet"
  }
  sudo::line { "www-data-save-puppet-config":
    line => "www-data	ALL=(root) NOPASSWD: /usr/local/sbin/save-puppet-config"
  }

}

class puppet::download-config {
  include cron

  file { "/usr/local/sbin/download-puppet-config":
    source => "puppet:///box/puppet/download-puppet-config",
    mode => 755
  }

  file { "/etc/cron.d/download-puppet-config":
    content => template("box/puppet/download-puppet-config.cron.d"),
    require => Package[cron]
  }
}
