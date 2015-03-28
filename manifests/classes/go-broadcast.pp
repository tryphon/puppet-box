class go-broadcast {
  include apt::tryphon::dev
  include apt::multimedia # required for lame, faac, aacplus

  package { "go-broadcast":
    ensure => "0.11+build132",
    require => [Apt::Source[tryphon-dev], Apt::Source[debian-multimedia]]
  }

  file { "/etc/default/go-broadcast":
    ensure => "/var/etc/default/go-broadcast"
  }

  file { "/etc/puppet/manifests/classes/go-broadcast.pp":
    source => "puppet:///box/go-broadcast/manifest.pp"
  }

  file { "/etc/puppet/templates/go-broadcast.default":
    # each Box can customize the go-broadcast daemon options with this template
    source => ['puppet:///files/go-broadcast/go-broadcast.default.erb', 'puppet:///box/go-broadcast/go-broadcast.default.erb']
  }

  file { '/usr/local/bin/go-broadcast-alsa-options':
    source => 'puppet:///box/go-broadcast/go-broadcast-alsa-options',
    mode => 755
  }

  include go-broadcast::munin
}

class go-broadcast::config {
  file { '/etc/box/local.d/go-broadcast':
    source => 'puppet:///box/go-broadcast/box-config.rb'
  }
  file { "/etc/go-broadcast":
    ensure => "/var/etc/go-broadcast"
  }
}

class go-broadcast::munin {
  include munin::ruby

  munin::plugin { gobroadcast_soundmeter:
    source => "puppet:///box/go-broadcast/munin/soundmeter"
  }
}
