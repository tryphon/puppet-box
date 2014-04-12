$alsa_device = generate("/usr/local/bin/alsa-device")

file { "/var/etc/asound.conf":
  content => template("/etc/puppet/templates/alsa/asound.conf"),
  tag => boot
}
