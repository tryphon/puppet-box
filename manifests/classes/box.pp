class box {
  include network
  include network::interfaces

  include linux::kernel-2-6-30
  include syslog
  include smtp
  include nano
  include ssh
  
  include dbus::readonly
  include avahi
  
  include apt
  include apt::tryphon
  include puppet
  include sudo

  include release

  include munin::readonly
  include munin-node

  include ntp::readonly
}

class box::audio {
  include alsa::common
  include alsa::readonly
  include alsa::mixer
}

class box::storage {
  include mdadm
  include storage-tools
  # TODO completed with PigeBox/StageBox/ChouetteBox 
}
