$mysql_real_directory = generate("/bin/readlink","/var/lib/mysql")

file { $mysql_real_directory:
  ensure => directory,
  owner => mysql,
  group => mysql,
  mode => 700,
  require => Exec["storage-mount-<%= box_storage_name %>"],
  tag => boot
}

exec { "mysql_install_db":
  command => "/usr/bin/mysql_install_db --rpm",
  creates => "/var/lib/mysql/mysql/user.MYD",
  require => File[$mysql_real_directory],
  tag => boot
}
