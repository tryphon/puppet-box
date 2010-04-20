class linux {

  define module() {
    line { "module-$name":
      file => "/etc/modules",
      line => $name
    }
  }

}
