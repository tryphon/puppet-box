class steto {
  include ruby::gems
  include ruby::gems::dependencies

  ruby::gem { steto: ensure => "0.0.7", require => Package[ruby-dev] }

  include network::dnsutils
  package { [nagios-plugins-basic, nagios-plugins-standard, beep]: }

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

  define conf($source = '', $content = '') {
    file { "/etc/steto/conf.d/${name}.rb":
      require => File["/etc/steto/conf.d"]
    }

    if $source != '' { 
      File["/etc/steto/conf.d/${name}.rb"] {
        source => $source
      }
    } else {
      File["/etc/steto/conf.d/${name}.rb"] {
        content => $content
      }
    }
  }

  steto::conf { "report-syslog": 
    source => "puppet:///box/steto/report-syslog.rb"
  }
  steto::conf { "00-helpers": 
    source => "puppet:///box/steto/helpers.rb"
  }
}
