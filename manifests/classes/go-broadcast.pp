class go-broadcast {
  include apt::tryphon::dev
  package { "go-broadcast":
    ensure => "0.11+build81",
    require => Apt::Source[tryphon-dev]
  }
}
