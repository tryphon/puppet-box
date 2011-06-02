class issue {
  link { "/etc/issue":
    target => "/var/etc/issue"
  }

  file { "/etc/puppet/manifests/classes/issue.pp":
    source => "puppet:///box/issue/manifest.pp"
  }

  file { "/usr/local/sbin/update-issue-file":
    source => "puppet:///box/issue/update-issue-file"
  }

  link { ["/etc/network/if-up.d/update-issue-file", "/etc/network/if-down.d/update-issue-file"]:
    target => "/usr/local/sbin/update-issue-file",
    require => [File["/usr/local/sbin/update-issue-file"], Package[ifupdown]]
  }
}
