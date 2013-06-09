class cron {
  package { cron: }

  include cron::sleep
}

class cron::sleep {
  include bc
  file { "/usr/local/bin/random-sleep":
    source => "puppet:///box/cron/random-sleep",
    mode => 755
  }
}
