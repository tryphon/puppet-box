exec { "update-issue-file":
  command => "/usr/local/sbin/update-issue-file",
  creates => "/var/etc/issue",
  tag => boot
}
