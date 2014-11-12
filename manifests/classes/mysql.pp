class mysql::server($storage_name) {
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
    ensure => "/srv/$storage_name/mysql",
    force => true,
    require => Package[mysql-server]
  }

  file { "/etc/puppet/manifests/classes/mysql.pp":
    content => template("box/mysql/manifest.pp")
  }

  file { "/etc/mysql/conf.d/bind-address.cnf":
    content => "[mysqld]\nbind-address          = 0.0.0.0\n",
    require => Package["mysql-server"]
  }

  file { "/etc/mysql/conf.d/max-connections.cnf":
    content => "[mysqld]\nmax_connections        = 200\n",
    require => Package["mysql-server"]
  }

  file { "/etc/mysql/debian.cnf":
    ensure => link,
    force => true,
    target => "/srv/$storage_name/mysql/debian.cnf",
    require => Package["mysql-server"]
  }

  file { '/usr/local/sbin/mysql-debian-sys-maint':
    source => 'puppet:///box/mysql/mysql-debian-sys-maint',
    mode => 0755
  }
}
