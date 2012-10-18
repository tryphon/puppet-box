class ruby::gems {
  file { "/etc/gemrc":
    content => "gem: --no-rdoc --no-ri\n",
    before => Package[rubygems]
  }
  if $debian::lenny {
    include apt::tryphon
    package { rubygems: 
      ensure => "1.3.7-1~bpo50+1",
      require => [Apt::Source::Pin[rubygems], Apt::Source::Pin["rubygems1.8"]]
    }
    apt::source::pin { [rubygems, "rubygems1.8"]:
      source => "lenny-backports",
      require => Apt::Source[tryphon]
    }
  } else {
    package { rubygems: }
  }

  exec { "rubygems-fix-date-format":
    command => 'sed -i "s/ 00:00:00.000000000Z//" /var/lib/gems/1.8/specifications/*.gemspec',
    refreshonly => true
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
