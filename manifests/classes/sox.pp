class sox {
  include apt::tryphon
  include apt::multimedia # required for lame

  package { [sox, libsox-fmt-mp3]: 
    ensure => "14.3.1-1~bpo50+1",
    require => [Apt::Source[tryphon], Apt::Source[debian-multimedia]] 
  }
}
