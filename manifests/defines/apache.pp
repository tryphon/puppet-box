define apache::module($config = false) {
  file { "/etc/apache2/mods-enabled/$name.load":
    ensure => "/etc/apache2/mods-available/$name.load",
    require => Package[apache]
  }

  if $config {
    file { "/etc/apache2/mods-enabled/$name.conf":
      ensure => "/etc/apache2/mods-available/$name.conf",
      require => Package[apache]
    }
  }
}

define apache::confd($source = '') {
  $real_source = $source ? {
    '' => ["puppet:///files/apache2/conf.d/$name", "puppet:///box/apache2/conf.d/$name"],
    default => $source
  }
  file { "/etc/apache2/conf.d/$name":
    source => $real_source,
    require => Package[apache]
  }
}
