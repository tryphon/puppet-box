class ruby::gems {
  if $debian::lenny {
    include apt::tryphon
    package { rubygems: 
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
