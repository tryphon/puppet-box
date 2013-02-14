class release {
  include release::current
  include release::upgrade
  include release::cron
}

class release::current {
  file { "/boot/current.yml":
    content => template("box/release/current.yml")
  }
}

class release::upgrade {
  file { "/usr/local/sbin/box-upgrade":
    source => "puppet:///box/release/box-upgrade",
    mode => 755
  }
  sudo::line { "www-data-box-upgrade":
    line => "www-data	ALL=(root) NOPASSWD: /usr/local/sbin/box-upgrade"
  }

  steto::conf { release-upgrade: 
    source => "puppet:///box/release/steto.rb"
  }
}

class release::cron {
  $cron_command = "/usr/local/bin/box release upgrade"

  file { "/etc/cron.d/box-release":
    content => "30 *    * * *   root	test -f /var/etc/box/auto_upgrade && $cron_command\n",
    require => [Package[tryphon-box], Package[cron]]
  }
}
