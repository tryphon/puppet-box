exec { "storage-init-<%= storage_name %>":
  command => "/usr/local/sbin/storage init --label=<%= storage_name %> > /var/log/storage-<%= storage_name %>.log",
  tag => boot
}

exec { "storage-mount-<%= storage_name %>":
  command => "mount /srv/<%= storage_name %>",
  unless => "mount | grep /srv/<%= storage_name %>",
  require => Exec["storage-init-<%= storage_name %>"],
  tag => boot
}
