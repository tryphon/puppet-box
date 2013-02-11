class sox {
  include apt::tryphon
  include apt::multimedia # required for lame

  $version = $debian::release ? {
    lenny => "14.3.1-1~bpo50+2",
    squeeze => "14.4.0-3~bpo60+2",
    default => "latest"
  }

  package { [sox, libsox-fmt-mp3]: 
    ensure => $version,
    require => [Apt::Source[tryphon], Apt::Source[debian-multimedia]] 
  }
}

class sox::ruby {
  ruby::gem { rsox-command: ensure => latest }
}
