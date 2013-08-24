class go-broadcast {
  package { go-broadcast:
    ensure => "0.5-1",
    require => Apt::Source[tryphon]
  }
}
