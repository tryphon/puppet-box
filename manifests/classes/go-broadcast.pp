class go-broadcast {
  package { "go-broadcast":
    ensure => "0.10",
    require => Apt::Source[tryphon]
  }
}
