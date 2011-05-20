class ruby::gems {
  include apt::backport

  package { rubygems: 
    require => [Apt::Source::Pin[rubygems], Apt::Source::Pin["rubygems1.8"]]
  }
  apt::source::pin { [rubygems, "rubygems1.8"]:
    source => "lenny-backports"
  }
}
