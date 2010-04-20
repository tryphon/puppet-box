class alsa::common {
  # TODO use explicity like other readonly class
  include alsa::readonly

  include alsa::mixer
  package { alsa-utils: }
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
}
