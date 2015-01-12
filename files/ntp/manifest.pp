class ntp {
  file { '/var/etc/ntp.conf':
    content => template('ntp.conf'),
    tag => boot
  }

  service { ntp:
    subscribe => File['/var/etc/ntp.conf']
  }
}

include ntp
