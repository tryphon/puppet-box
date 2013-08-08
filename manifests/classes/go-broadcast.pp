class go-broadcast {
  package { go-broadcast:
    ensure => "0.4-1",
    require => Apt::Source[tryphon]
  }
}
