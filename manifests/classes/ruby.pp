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
}

class ruby::gems::dependencies {
  package { [ruby-dev, build-essential]: }
}
