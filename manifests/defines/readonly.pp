define readonly::mount_tmpfs() {
  line { "fstab-with-tmfs-$name":
    file => "/etc/fstab",
    line => "tmpfs ${name} tmpfs defaults,noatime 0 0"
  }
}
