define initd_script() {
  exec { "insserv-${name}":
    command => "insserv ${name}",
    unless => "ls /etc/rc?.d/S*${name} > /dev/null 2>&1",
    require => File["/etc/init.d/${name}"]
  }
}
