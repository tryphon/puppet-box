class locales {
  package { locales: }

  file { "/etc/locale.gen":
    content => "en_US.UTF-8 UTF-8\nfr_FR.UTF-8 UTF-8\n",
    require => Package[locales]
  }

  exec { "/usr/sbin/locale-gen":
    subscribe => File["/etc/locale.gen"],
    refreshonly => true,
    require => File["/etc/locale.gen"]
  }

  file { "/etc/puppet/manifests/classes/locales.pp":
    source => "puppet:///box/locales/manifest.pp"
  }

  file { "/etc/default/locale":
    ensure => "/var/etc/default/locale",
    force => true,
    require => Package[locales]
  }

  package { "keyboard-configuration": }

  file { "/etc/default/keyboard":
    ensure => "/var/etc/default/keyboard",
    require => Package["keyboard-configuration"]
  }
}
