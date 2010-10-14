class sudo {
  package { sudo: }

  # file { "/etc/sudoers":
  #   source => "puppet:///box/sudo/sudoers",
  #   mode => 0440,
  #   require => Package[sudo]
  # }

  define line($line) {
    ::line { "sudo-$name":
      file => "/etc/sudoers",
      line => $line,
      require => Package[sudo]
    }
  }

}
