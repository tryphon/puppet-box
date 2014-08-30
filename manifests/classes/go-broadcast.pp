class go-broadcast {
  include apt::tryphon::dev

  package { "go-broadcast":
    ensure => "0.11+build99",
    require => Apt::Source[tryphon-dev]
  }
  include go-broadcast::munin
}

class go-broadcast::munin {
  include munin::ruby

  munin::plugin { gobroadcast_soundmeter:
    source => "puppet:///box/go-broadcast/munin/soundmeter"
  }
}
