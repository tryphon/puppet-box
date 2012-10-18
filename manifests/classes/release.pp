class release {
  include release::current
  include release::upgrade
  include release::gem
  include release::conf
}

class release::conf {
  file { "/etc/box/release.conf": ensure => "/var/etc/box/release.conf" }

  file { "/etc/puppet/manifests/classes/release.pp":
    source => "puppet:///box/release/manifest.pp",
  }
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

class release::gem {
  ruby::gem { box-release: ensure => latest }

  ruby::gem { SyslogLogger: require => Ruby::Gem[hoe] }
  ruby::gem { hoe: ensure => '2.8.0' }
}

class release::cron {
  include release::current
  include release::upgrade
  include release::gem

  $real_release_cron_before_download = $release_cron_before_download ? {
    '' => "/bin/true",
    default => $release_cron_before_download
  }
  $real_release_cron_after_download = $release_cron_after_download ? {
    '' => "/bin/true",
    default => $release_cron_after_download
  }
  $download_directory_option = $release_cron_download_directory ? {
    '' => '',
    default => "--download-dir=$release_cron_download_directory"
  }
  $cron_command = "/var/lib/gems/1.8/bin/box-release --current /boot/current.yml --install /usr/local/sbin/box-upgrade --before-download='$real_release_cron_before_download' --after-download='$real_release_cron_after_download' $download_directory_option http://download.tryphon.eu/$box_name/latest.yml"

  file { "/etc/cron.d/box-release":
    content => "30 *    * * *   root	$cron_command\n",
    require => [Package[box-release], Package[cron]]
  }
}
