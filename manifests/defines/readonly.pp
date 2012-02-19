define readonly::mount_tmpfs($options = false) {
  $additional_options = $options ? {
    false => '',
    default => ",$options"
  }
  mount { $name:
    ensure => defined,
    fstype => "tmpfs",
    device => "tmpsfs",
    options => "defaults,noatime${additional_options}"
  }
}
