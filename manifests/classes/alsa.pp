class alsa::common {
  # TODO use explicity like other readonly class
  include alsa::readonly
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
