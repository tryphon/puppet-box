if $locale == "" {
  $locale = "en"
}

$locale_lang = $locale ? {
  'fr' => 'fr_FR.UTF-8',
  default => 'en_US.UTF-8'
}

file { "/var/etc/default/locale":
  content=>"LANG=${locale_lang}\n",
  tag => boot
}
     
file { "/var/etc/default/keyboard":
  content=>"XKBMODEL=\"pc105\"\nXKBLAYOUT=\"${locale}\"\nXKBVARIANT=\"\"\nXKBOPTIONS=\"\"\n",
  tag => boot
}
     
