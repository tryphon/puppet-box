define readonly::mount_tmpfs($options = false) {
  $additional_options = $options ? {
    false => '',
    default => ",$options"
  }
  line { "fstab-with-tmfs-$name":
    file => "/etc/fstab",
    line => "tmpfs ${name} tmpfs defaults,noatime${additional_options} 0 0"
  }
}
