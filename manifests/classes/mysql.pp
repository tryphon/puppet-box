class mysql::server {
  package { "mysql-server": }

  file { "/var/lib/mysql":
    ensure => "/srv/$box_storage_name/mysql",
    force => true
  }

  file { "/etc/puppet/manifests/classes/mysql.pp":
    content => template("box/mysql/manifest.pp")
  }
}
