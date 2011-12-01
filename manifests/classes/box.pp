class box {
  include network
  include network::interfaces

  include linux::kernel-2-6-30
  include syslog
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

  include munin::all

  include ntp::readonly

  include lshw
  include hal
}

class box::audio {
  include alsa::common
  include alsa::readonly
  include alsa::mixer
  include box::user
}

class box::storage {
  include mdadm

  # TODO completed with PigeBox/StageBox/ChouetteBox 

  file { "/srv/$box_storage_name":
    ensure => directory
  }

  line { "fstab-pige":
    file => "/etc/fstab",
    line => "LABEL=$box_storage_name /srv/$box_storage_name ext3 defaults 0 0"
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
    groups => [audio]
  }
  link { "/home/boxuser":
    target => "/boot/boxuser"
#TODO find a way to make this operation dependant of the presence of the target dir in /boot
  }

  sudo::line { "boxuser-reboot":
    line => "boxuser ALL=(root) NOPASSWD: /sbin/reboot"
  }

  sudo::line { "boxuser-syslog":
    line => "boxuser ALL=(root) NOPASSWD: tail -f /var/log/syslog"
  }

}
