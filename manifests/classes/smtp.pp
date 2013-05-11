class smtp {
  # disable exim4 installed by default
  package { ["exim4-daemon-light", "exim4", "exim4-base", "exim4-config", "exim4-daemon-heavy"]: 
    ensure => purged 
  }
}
