class go-broadcast {
  package { "go-broadcast":
    ensure => "0.9",
    require => Apt::Source[tryphon]
  }
}
