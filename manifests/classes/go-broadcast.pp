class go-broadcast {
  package { go-broadcast:
    ensure => "0.7",
    require => Apt::Source[tryphon]
  }
}
