class hal {
  package { hal: }
  readonly::mount_tmpfs { "/var/cache/hald": }

  if $debian::lenny {
    package { acpid: 
      ensure => "1.0.10-5~bpo50+1",
      require => Apt::Source::Pin[acpid] 
    }
    apt::source::pin { "acpid":
      source => "lenny-backports"
    }
  } else {
    package { acpid: }
  }

  file { "/etc/acpi/events/powerbtn":
    source => "puppet:///box/acpi/powerbtn",
    require => Package[acpid]
  }
  file { "/etc/acpi/powerbtn.sh":
    mode => 755,
    source => "puppet:///box/acpi/powerbtn.sh",
    require => Package[acpid]
  }

}
