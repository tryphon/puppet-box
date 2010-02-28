class linux {

  define module() {
    line { "module-$name":
      file => "/etc/modules",
      line => $name
    }
    exec { "modprobe $name":
      unless => "lsmod | sed 's/_/-/g' | grep -q $name"
    }
  }

}
