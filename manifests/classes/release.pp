class release {
  include release::current
  include release::upgrade
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
}

class release::cron {
  include release::current
  include release::upgrade

  ruby::gem { box-release: }

  ruby::gem { SyslogLogger: require => Ruby::Gem[hoe] }
  ruby::gem { hoe: ensure => '2.8.0' }

  $real_release_cron_before_download = $release_cron_before_download ? {
    '' => "/bin/true",
    default => $release_cron_before_download
  }

  file { "/etc/cron.d/box-release":
    content => "30 *    * * *   root	/var/lib/gems/1.8/bin/box-release --current /boot/current.yml --install /usr/local/sbin/box-upgrade --before-download='$real_release_cron_before_download' http://download.tryphon.eu/$box_name/latest.yml\n",
    require => Package[box-release]
  }
}
