class go-broadcast {
  package { "go-broadcast":
    ensure => "0.8",
    require => Apt::Source[tryphon]
  }
}
