file { "/var/etc/wpa_supplicant":
  ensure => directory,
  tag => boot
}

if $wifi_networks {
  file { "/var/etc/wpa_supplicant/wpa_supplicant.conf":
    content => template("network/wpa_supplicant.conf"),
    tag => boot
  }
}
