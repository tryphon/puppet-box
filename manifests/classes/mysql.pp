class mysql::server {
  # FIXME workaround to ignore user creation problem
  file { "/usr/local/bin/ypwhich":
    ensure => "/bin/true",
    before => Package["mysql-server"]
  }

  group { mysql:
    gid => 2010
  }

  user { mysql:
    uid => 2010,
    gid => mysql,
    home => "/var/lib/mysql",
    require => Group[mysql],
    shell => "/bin/false"
  }

  package { "mysql-server": 
    require => [User[mysql], Group[mysql]]
  }

  file { "/var/lib/mysql":
    ensure => "/srv/$box_storage_name/mysql",
    force => true
  }

  file { "/etc/puppet/manifests/classes/mysql.pp":
    content => template("box/mysql/manifest.pp")
  }

  file { "/etc/mysql/conf.d/bind-address.cnf":
    content => "[mysqld]\nbind-address          = 0.0.0.0\n",
    require => Package["mysql-server"]
  }
}
