class ruby::gems {
  file { "/etc/gemrc":
    content => "gem: --no-rdoc --no-ri\n"
  }

  package { ["ruby1.9.1", "ruby1.9.1-dev"]:
    ensure => "1.9.3.484-1~bpo60+1",
    require => Apt::Source[tryphon]
  }

  include ruby::gems::tryphon
}

class ruby::gems::tryphon {
  $tryphon_repository = "http://download.tryphon.eu/rubygems/"

  exec { "gem-source-tryphon":
    command => "gem source --add $tryphon_repository",
    unless => "gem source --list | grep $tryphon_repository"
  }
}

class ruby::gems::dependencies {
  package { [ruby-dev, build-essential]: }
}

class ruby::bundler {
  ruby::gem { bundler: }
}
