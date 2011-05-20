class ruby::gems {
  include apt::backport

  package { rubygems: 
    require => Apt::Source::Pin[rubygems]
  }
  apt::source::pin { rubygems:
    source => "lenny-backports"
  }
}
