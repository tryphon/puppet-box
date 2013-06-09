class locales {
  file { "/etc/default/locale":
    content => "LANG=C\n"
  }
}
