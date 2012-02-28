exec { "storage-init-<%= box_storage_name %>":
  command => "/usr/local/sbin/storage init --label=<%= box_storage_name %> > /var/log/storage-<%= box_storage_name %>.log",
  tag => boot
}

exec { "storage-mount-<%= box_storage_name %>":
  command => "mount /srv/<%= box_storage_name %>",
  unless => "mount | grep /srv/<%= box_storage_name %>",
  require => Exec["storage-init-<%= box_storage_name %>"],
  tag => boot
}
