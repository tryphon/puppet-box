class storage {
  # FIXME deprecated, use storage init instead
  file { "/usr/local/sbin/format-storage":
    source => "puppet:///box/storage/format-storage",
    mode => 755
  }

  file { "/usr/local/sbin/storage":
    source => "puppet:///box/storage/storage.rb",
    mode => 755
  }
}
