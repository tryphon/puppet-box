class proftpd::steto {
  steto::conf { proftpd: 
    source => "puppet:///box/proftpd/steto.rb"
  }
}
