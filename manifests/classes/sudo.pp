class sudo {
  package { sudo: }

  readonly::mount_tmpfs { "/var/lib/sudo": }

  define line($line) {
    ::line { "sudo-$name":
      file => "/etc/sudoers",
      line => $line,
      require => Package[sudo]
    }
  }
}
