class storage {
  file { "/usr/local/sbin/format-storage":
    source => "puppet:///box/storage/format-storage",
    mode => 755
  }
}
