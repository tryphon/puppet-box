class box {
  include network
  include network::interfaces

  include linux::kernel-2-6-30
  include syslog
  # to allow www-data to read syslog
  include apache::syslog
  include smtp
  include nano
  include ssh
  include cron
  
  include dbus::readonly
  include avahi
  
  include apt
  include apt::tryphon
  include puppet
  include sudo

  include release
  include issue

  include steto
  include munin::all

  include ntp::readonly

  include lshw
  include hal

  include box::user
}

class box::audio {
  include alsa::common
  include alsa::readonly
  include alsa::mixer
}

class box::storage {
  include mdadm

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

  sudo::line { "boxuser-syslog":
    line => "boxuser	ALL=(root) NOPASSWD: /usr/bin/tail -f /var/log/syslog"
  }

  file { "/usr/local/bin/syslog":
    content => "#!/bin/sh\nsudo /usr/bin/tail -f /var/log/syslog\n",
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
