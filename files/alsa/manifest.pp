$alsa_device = generate("/usr/local/bin/alsa-device")

class alsa {
  $device_id = inline_template("<%= File.read('/proc/asound/card0/id').chomp %>")

  # OPTIMIZEME specific to RivendellBoxes (see #1087)
  if $alsa_config == "" and $alsa::device_id == "DSP" {
    notice("Define default alsa_config for RME HDSP support")
    $alsa_config = { "pcm.rd0" => { "type" => "plug", "slave.pcm" => "hw:0" } }
  }

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

}

include alsa
