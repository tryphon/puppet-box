$alsa_device = generate("/usr/local/bin/alsa-device")

if $alsa_config != "" {
  file { "/var/etc/asound.conf":
    content => template("/etc/puppet/templates/alsa/asound.conf"),
    tag => boot
  }
} else {
  file { "/var/etc/asound.conf":
    source => "/etc/puppet/files/alsa/asound.conf.default",
    tag => boot
  }
}
