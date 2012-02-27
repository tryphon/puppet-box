file { "/var/etc/box": 
  ensure => directory,
  tag => boot
}

if $release_server == "" {
  $release_server="http://download.tryphon.eu"
}

file { "/var/etc/box/release.conf": 
  content => "release_server=$release_server\n",
  tag => boot
}
