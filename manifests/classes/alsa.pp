class alsa::common {
  # TODO use explicity like other readonly class
  include alsa::readonly

  include alsa::mixer
  package { alsa-utils: }

  file { "/usr/local/sbin/lsof-alsa":
    source => "puppet:///box/alsa/lsof-alsa",
    mode => 775
  }

  file { "/usr/local/bin/alsa-device":
    source => "puppet:///box/alsa/alsa-device",
    mode => 775
  }

  file { "/etc/puppet/manifests/classes/alsa.pp":
    source => "puppet:///box/alsa/manifest.pp"
  }
}

class alsa::readonly {
  include readonly
  readonly::mount_tmpfs { "/var/lib/alsa": }
}  

class alsa::oss {
  include linux
  linux::module { snd-pcm-oss: }
}

class alsa::mixer {
  file { "/usr/local/bin/amixerconf":
    source => "puppet:///box/alsa/amixerconf",
    mode => 775
  }

  file { "/etc/init.d/amixerconf":
    source => "puppet:///box/alsa/amixerconf.init",
    mode => 775
  }

  $real_amixerconf_mode = $amixerconf_mode ? {
    '' => "capture",
    default => $amixerconf_mode
  }

  file { "/etc/default/amixerconf":
    content => template("box/alsa/amixerconf.default")
  }

  if $debian::lenny {
    exec { "update-rc.d-amixerconf":
      command => "update-rc.d amixerconf start 51 S .",
      require => File["/etc/init.d/amixerconf"],
      creates => "/etc/rcS.d/S51amixerconf"
    }   
  } else {
    exec { "update-rc.d-amixerconf":
      command => "insserv amixerconf",
      require => File["/etc/init.d/amixerconf"],
      unless => "ls /etc/rc?.d/S*amixerconf > /dev/null 2>&1"
    }   
  }
}
