class sudo {
  package { sudo: }

  define line($line) {
    ::line { "sudo-$name":
      file => "/etc/sudoers",
      line => $line,
      require => Package[sudo]
    }
  }
}
