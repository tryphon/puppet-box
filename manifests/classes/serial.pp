class serial::console {
  line { "inittab-getty-ttyS0":
    file => "/etc/inittab",
    line => "T0:23:respawn:/sbin/getty -L ttyS0 9600 vt100"
  }
}
