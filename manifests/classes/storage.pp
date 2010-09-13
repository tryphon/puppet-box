class storage-tools {
  file { "/usr/local/sbin/storage":
    source => "puppet:///box/storage/storage.rb",
    mode => 755
  }
}
