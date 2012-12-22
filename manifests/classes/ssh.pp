class ssh {
  package { ssh: }

  file { 
    "/root/.ssh/authorized_keys":
    source => "puppet:///box/ssh/authorized_keys",
    mode => 700;

    "/root/.ssh": 
    ensure => directory, mode => 700;
  }

  steto::conf { "ssh": 
    source => "puppet:///box/ssh/steto.rb"
  }
}
