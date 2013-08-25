class go-broadcast {
  package { go-broadcast:
    ensure => "0.6-1",
    require => Apt::Source[tryphon]
  }
}
