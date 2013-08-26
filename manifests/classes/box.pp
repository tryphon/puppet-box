class box {
  include network
  include network::interfaces

  include linux::kernel-2-6-30
  include syslog
  include logrotate
  # to allow www-data to read syslog
  include apache::syslog
  include smtp
  include nano
  include ssh
  include cron
  include locales

  include reverse-tunnel

  include dbus::readonly
  include avahi

  include apt
  include apt::tryphon
  include puppet
  include sudo

  include release
  include issue

  include steto
  include steto::apache
  include munin::all

  include ntp::readonly

  include lshw
  include hal

  include box::gem
  include box::user
  include box::daemon
  include box::conf
  include box::root
}

define box::config::migration($source) {
  file { "/etc/box/migrations/$name.rb" :
    source => $source
  }
}

class box::gem {
  file { "/etc/box": ensure => directory }

  ruby::gem { tryphon-box: ensure => "0.0.12" }
  ruby::gem { SyslogLogger: ensure => "2.0" }

  file { "/etc/cron.d/box":
    content => "*/5 *    * * *   root	/usr/local/bin/random-sleep 50 5 && /usr/local/bin/box provisioning sync\n",
    require => Package[cron]
  }

  file { "/etc/box/registration_secret":
    content => "secret",
    mode => 600
  }
}

class box::conf {
  file { "/etc/box/config.rb":
    content => template("box/box/config.rb")
  }

  # Contains migrations for the Box
  file { "/etc/box/migrations":
    ensure => directory
  }

  # Contains customized config for the Box
  file { "/etc/box/local.d/":
    ensure => directory
  }

  # Contains customized config at runtime
  file { "/etc/box/local.rb": ensure => "/var/etc/box/local.rb" }

  file { "/etc/puppet/manifests/classes/box-config.pp":
    source => "puppet:///box/box/manifest.pp",
  }
  file { "/etc/puppet/templates/config-local.rb":
    source => "puppet:///box/box/config-local.rb",
  }
}

class box::audio {
  include alsa::common
  include alsa::readonly
  include alsa::mixer
}

class box::storage {
  include mdadm
  include storage-utils

  # TODO completed with PigeBox/StageBox/ChouetteBox

  file { "/srv/$box_storage_name":
    ensure => directory
  }

  mount { "/srv/$box_storage_name":
    ensure => defined,
    fstype => "ext3",
    device => "LABEL=$box_storage_name",
    options => "defaults"
  }

  file { "/usr/local/sbin/storage":
    source => "puppet:///box/storage/storage.rb",
    mode => 755
  }

  file { "/etc/puppet/manifests/classes/storage-${box_storage_name}.pp":
    content => template("box/storage/manifest.pp")
  }

  steto::conf { "storage":
    source => "puppet:///box/storage/steto.rb"
  }

  steto::conf { "storage-$box_storage_name":
    content => "StorageCheck.new(:$box_storage_name).config(Steto.config)\n"
  }

}

class box::daemon {
  user { boxdaemon:
    uid => 2020,
    groups => [audio]
  }
}

class box::user {
  user { boxuser:
    groups => [audio, adm]
  }

  file { "/home/boxuser":
    ensure => directory
  }

  readonly::mount_tmpfs { "/home/boxuser":
    options => "size=15M,uid=boxuser,gid=boxuser,mode=0700",
    require => User[boxuser]
  }

  sudo::line { "boxuser-reboot":
    line => "boxuser	ALL=(root) NOPASSWD: /sbin/reboot"
  }

  file { "/usr/local/bin/syslog":
    content => "#!/bin/sh\n/usr/bin/tail -f /var/log/syslog\n",
    mode => 755
  }

  file { "/etc/skel/.ssh":
    ensure => directory,
    mode => 0700
  }

  # Requires to sync boxuser home on boot
  include rsync

  file { "/etc/puppet/manifests/classes/boxuser.pp":
    source => "puppet:///box/boxuser/manifest.pp"
  }
}

class box::root {
  user { root:
    password => ""
  }
}
