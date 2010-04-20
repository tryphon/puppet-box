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
