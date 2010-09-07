# Support now only local key files
define apt::key($ensure = present, $source) {
  case $ensure {
    present: {
      file { "/etc/apt/${name}.key":
        source => $source
      }
      exec { "/usr/bin/apt-key add /etc/apt/${name}.key":
        unless => "apt-key list | grep -Fqe '${name}'",
        require => File["/etc/apt/${name}.key"]
      }
    }
    
    absent: {
      file { "/etc/apt/${name}.key":
        ensure => absent
      }
      exec {"/usr/bin/apt-key del ${name}":
        onlyif => "apt-key list | grep -Fqe '${name}'",
      }
    }
  }
}

define apt::source($key) {
  apt::key { $key:
    source => "puppet:///box/apt/$name.key"
  }
  file { "/etc/apt/sources.list.d/$name.list":
    source => "puppet:///box/apt/$name.list",
    require => Apt::Key[$key],
    notify => Exec["apt-get-update-for-source-${name}"]
  } 
  exec { "apt-get-update-for-source-${name}":
    command => "apt-get update",
    refreshonly => true
  }
}

define apt::source::pin($source, $release = false) {
  $real_release = $release ? {
    false => $source,
    default => $release
  }

  apt::preferences { $name:
    package => $name, 
    pin => "release a=$real_release",
    priority => 999,
    require => Apt::Source[$source]
  }
}

define apt::preferences($ensure="present", $package, $pin, $priority) {
  concatenated_file_part { $name:
    ensure  => $ensure,
    dir    => "/etc/apt/preferences.d",
    content => "# file managed by puppet
Package: $package
Pin: $pin
Pin-Priority: $priority
",
    notify => Exec["update-apt-preferences-for-$name"]
  }
  # OPTIMIZE same action than exec { "concat_${name}" }
  # Ensure that apt/preferences file is updated now
  exec { "update-apt-preferences-for-$name":
    command => "/usr/bin/find /etc/apt/preferences.d -maxdepth 1 -type f ! -name '*puppettmp' -print0 | sort -z | xargs -0 cat >| /etc/apt/preferences",
    refreshonly => true
  } 
}
