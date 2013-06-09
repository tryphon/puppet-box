class readonly::common {
  file { "/var/etc":
    ensure => directory
  }

  readonly::mount_tmpfs { "/var/etc": }

  file { "/var/log.model":
    ensure => directory
  }
  file { "/var/log.model/dmesg":
    ensure => present
  }
  file { "/var/log.model/lastlog":
    ensure => present,
    group => utmp,
    mode => 664
  }

  link { "/etc/mtab":
    target => "/proc/mounts"
  }

  readonly::mount_tmpfs { "/var/lib/urandom": }

  file { "/etc/puppet/manifests/classes/readonly.pp":
    source => "puppet:///box/readonly/manifest.pp"
  }
}

class readonly::rootfs {
  # mount { ... } tries to (u)mount root fs ...
  line { "fstab-with-rootfs-ro":
    file => "/etc/fstab",
    line => "LABEL=root / ext3 defaults,ro 0 0"
  }
}

# DEPRECATED replaced by puppet management of /var/log.model
class readonly::initvarlog {

  file { "/etc/init.d/varlog":
    source => "puppet:///box/readonly/varlog.initd",
    mode => 775
  }

  exec { "update-rc.d-varlog":
    command => "update-rc.d varlog start 38 S . stop 40 0 6 .",
    subscribe => File["/etc/init.d/varlog"],
    creates => "/etc/rcS.d/S38varlog"
  }

}
