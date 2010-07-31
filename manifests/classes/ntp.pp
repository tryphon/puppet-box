class ntp {
  package { ntp: }
}

class ntp::readonly {
  include ntp
  readonly::mount_tmpfs { "/var/lib/ntp": }
}
