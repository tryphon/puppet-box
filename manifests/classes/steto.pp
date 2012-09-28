class steto {
  include ruby::gems
  include ruby::gems::dependencies

  ruby::gem { steto: ensure => latest, require => Package[ruby-dev] }
  package { ["nagios-plugins-basic", "nagios-plugins-standard", "beep"]: }

  file { ["/etc/steto", "/etc/steto/conf.d"]:
    ensure => directory
  }
  file { "/usr/local/sbin/steto-cron":
    source => "puppet:///box/steto/cron.rb",
    mode => 755
  }
  file { "/etc/cron.d/steto":
    content => "* *    * * *   root	/usr/local/sbin/steto-cron\n",
    require => Package[cron]
  }

  file { "/var/lib/steto":
    ensure => directory
  }
  readonly::mount_tmpfs { "/var/lib/steto": }

  define conf($source) {
    file { "/etc/steto/conf.d/${name}.rb":
      source => $source,
      require => File["/etc/steto/conf.d"]
    }
  }

  steto::conf { "report-syslog": 
    source => "puppet:///box/steto/report-syslog.rb"
  }
  steto::conf { "00-helpers": 
    source => "puppet:///box/steto/helpers.rb"
  }
}
