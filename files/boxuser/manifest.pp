exec { "boxuser-rsync-home":
  command => "rsync -a /etc/skel/ /home/boxuser/ && chown -R boxuser:boxuser /home/boxuser",
  user => boxuser,
  creates => "/home/boxuser/.profile",
  tag => boot
}

if $ssh_authorized_keys {
  file { "/home/boxuser/.ssh/authorized_keys":
    content => "$ssh_authorized_keys",
    owner => boxuser,
    group => boxuser,
    mode => 0600,
    tag => boot,
    require => Exec["boxuser-rsync-home"]
  }
}

