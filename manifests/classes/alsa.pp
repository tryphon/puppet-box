class alsa::common {
  # TODO use explicity like other readonly class
  include alsa::readonly

  include alsa::mixer
  package { alsa-utils: }
  package { alsa-tools: }
  package { alsa-tools-gui: }

  file { "/usr/local/sbin/lsof-alsa":
    source => "puppet:///box/alsa/lsof-alsa",
    mode => 775
  }

  file { "/usr/local/bin/alsa-device":
    source => ["puppet:///files/alsa/alsa-device", "puppet:///box/alsa/alsa-device"],
    mode => 775
  }

  file { "/etc/puppet/manifests/classes/alsa.pp":
    source => "puppet:///box/alsa/manifest.pp"
  }

  file { "/etc/puppet/templates/alsa":
    ensure => directory
  }

  file { "/etc/puppet/templates/alsa/asound.conf":
    source => "puppet:///box/alsa/asound.conf"
  }

  file { "/etc/asound.conf":
    ensure => link,
    target => "/var/etc/asound.conf"
  }

  file { "/etc/puppet/files/alsa":
    ensure => directory
  }

  file { "/etc/puppet/files/alsa/asound.conf.default":
    # Default asound.conf can be changed by Box project
    source => ["puppet:///files/alsa/asound.conf.default", "puppet:///box/alsa/asound.conf.default"]
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

  initd_script { 'amixerconf': }
}
