class proftpd::steto {
  steto::conf { proftpd:
    source => "puppet:///box/proftpd/steto.rb"
  }
}

class proftpd::common {
  user { ftp:
    uid => 2050,
    gid => 2050,
    shell => '/bin/sh'
  }
  group { ftp:
    gid => 2050
  }
}
