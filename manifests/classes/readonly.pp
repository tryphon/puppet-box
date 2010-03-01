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

  # mount { ... } tries to (u)mount root fs ...
  line { "fstab-with-rootfs-ro":
    file => "/etc/fstab",
    line => "LABEL=root / ext3 defaults,ro 0 0"
  }
  file { "/etc/mtab":
    ensure => "/proc/mounts"
  }

}

# DEPRECATED replaced by puppet management of /var/log.model
class readonly::initvarlog {

  file { "/etc/init.d/varlog":
    source => "$source_base/files/readonly/varlog.initd",
    mode => 775
  }

  exec { "update-rc.d-varlog":
    command => "update-rc.d varlog start 38 S . stop 40 0 6 .",
    subscribe => File["/etc/init.d/varlog"],
    creates => "/etc/rcS.d/S38varlog"
  }

}
