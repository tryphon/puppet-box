class alsa::common {

  package { alsa-utils: }

  readonly::mount_tmpfs { "/var/lib/alsa": }

}

class alsa::oss {
  include linux

  linux::module { snd-pcm-oss: }
}
