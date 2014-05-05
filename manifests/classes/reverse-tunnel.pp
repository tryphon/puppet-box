class reverse-tunnel {
  ruby::gem { 'reverse-tunnel': }

  file { '/etc/init.d/reverse-tunnel':
    source  => 'puppet:///box/reverse-tunnel/reverse-tunnel.init',
    require => File['/etc/default/reverse-tunnel'],
    mode    => '0775'
  }

  initd_script { 'reverse-tunnel': }

  file { '/etc/puppet/templates/reverse-tunnel.default':
    source => 'puppet:///box/reverse-tunnel/reverse-tunnel.default.erb'
  }
  file { '/etc/puppet/manifests/classes/reverse-tunnel.pp':
    source => 'puppet:///box/reverse-tunnel/manifest.pp'
  }

  file { '/etc/default/reverse-tunnel':
    ensure => link,
    target => '/var/etc/default/reverse-tunnel'
  }
}
