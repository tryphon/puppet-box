class release {
  include release::current
  include release::upgrade
}

class release::current {
  file { "/boot/current.yml":
    content => template("box/release/current.yml")
  }
}

class release::upgrade {
  file { "/usr/local/sbin/box-upgrade":
    source => "puppet:///box/release/box-upgrade",
    mode => 755
  }
}
