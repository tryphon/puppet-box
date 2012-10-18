class ntp {
  package { ntp: }

  steto::conf { "ntp": 
    source => "puppet:///box/ntp/steto.rb"
  }
}

class ntp::readonly {
  include ntp
  readonly::mount_tmpfs { "/var/lib/ntp": }
}
