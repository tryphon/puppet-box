class ntp {
  package { ntp: }

  file { '/etc/ntp.conf':
    ensure => link,
    target => '/var/etc/ntp.conf',
    force => true,
    require => Package['ntp']
  }

  file { "/etc/puppet/manifests/classes/ntp.pp":
    source => "puppet:///box/ntp/manifest.pp"
  }

  file { '/etc/puppet/templates/ntp.conf':
    source => 'puppet:///box/ntp/ntp.conf'
  }

  steto::conf { 'ntp':
    source => 'puppet:///box/ntp/steto.rb'
  }

  readonly::mount_tmpfs { '/var/lib/ntp': }
}
