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
  include storage-tools
  # TODO completed with PigeBox/StageBox/ChouetteBox 
}

class box::user {
  user { boxuser:
    groups => [audio]
  }
}
