# Retrieved from module puppet-apt

class apt {
  include debian

  exec { "apt-get_update":
    command => "apt-get update",
    refreshonly => true,
    require => File["/etc/apt/apt.conf.d/02recommended-suggested", "/etc/apt/apt.conf.d/02allow-unauthenticated"]
  }
  Package {
    require => Exec["apt-get_update"]
  }

  if $debian::lenny {
    concatenated_file { "/etc/apt/preferences":
      dir => "/etc/apt/preferences.d",
      before  => Exec["apt-get_update"]
    }
  }

  file { "/etc/apt/apt.conf.d/02recommended-suggested":
    content => "APT::Install-Recommends \"0\";\nAPT::Install-Suggests \"0\";"
  }
  file { "/etc/apt/apt.conf.d/02allow-unauthenticated":
    content => "APT::Get::AllowUnauthenticated \"true\";\n"
  }
}

class apt::tryphon {
  include debian

  if $debian::lenny {
    apt::source { tryphon:
      key => "C6ADBBD5",
      content => "deb http://debian.tryphon.eu ${debian::release}-backports main contrib\ndeb http://debian.tryphon.eu $debian::release main contrib"
    }
  } else {
    apt::source { tryphon:
      key => "C6ADBBD5",
      content => "deb http://debian.tryphon.eu $debian::release main contrib"
    }
  }
}

class apt::tryphon::dev {
  include apt
  apt::source { tryphon-dev:
    content => "deb http://dev.tryphon.priv/dist/debian/${debian::release}/${box_architecture}/ ./",
    require => File["/etc/apt/apt.conf.d/02allow-unauthenticated"]
  }
}

class apt::backport {
  # Provided by SystemBuilder
}

class apt::multimedia {
  include debian

  apt::source { debian-multimedia:
    key => "1F41B907",
    content => "deb http://debian-multimedia.tryphon.eu $debian::release main non-free"
  }
}

class apt::https {
  package { ['apt-transport-https', 'ca-certificates']: }
}
