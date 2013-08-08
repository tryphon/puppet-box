class cron {
  package { cron: }

  include cron::sleep
  include cron::user
}

class cron::sleep {
  include bc
  file { "/usr/local/bin/random-sleep":
    source => "puppet:///box/cron/random-sleep",
    mode => 755
  }
}

class cron::user {
  file { "/etc/puppet/templates/user-crons":
    source => "puppet:///box/cron/user-crons.erb"
  }
  file { "/etc/puppet/manifests/classes/cron.pp":
    source => "puppet:///box/cron/manifest.pp"
  }
  file { "/etc/cron.d/user-crons":
    ensure => "/var/etc/cron.d/user-crons"
  }
}
