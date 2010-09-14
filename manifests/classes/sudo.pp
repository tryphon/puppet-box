class sudo {
  package { sudo: }

  file { "/etc/sudoers":
    source => "puppet:///box/sudo/sudoers",
    mode => 0440,
    require => Package[sudo]
  }

}
