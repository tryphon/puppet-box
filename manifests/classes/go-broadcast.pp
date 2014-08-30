class go-broadcast {
  include apt::tryphon::dev
  include apt::multimedia # required for lame

  package { "go-broadcast":
    ensure => "0.11+build99",
    require => [Apt::Source[tryphon-dev], Apt::Source[debian-multimedia]]
  }
  include go-broadcast::munin
}

class go-broadcast::munin {
  include munin::ruby

  munin::plugin { gobroadcast_soundmeter:
    source => "puppet:///box/go-broadcast/munin/soundmeter"
  }
}
