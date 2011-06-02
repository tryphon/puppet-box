define link($target) {
  # Workaround to prevent this kind of error :
  # err: //network::interfaces/File[/etc/network/interfaces]/ensure: change from file to link failed: Could not set link on ensure: No such file or directory - /etc/network/interfaces at /tmp/puppet/modules/box/manifests/classes/network.pp:58
  # err: //readonly::common/File[/etc/mtab]/ensure: change from file to link failed: Could not set link on ensure: No such file or directory - /etc/mtab at /tmp/puppet/modules/box/manifests/classes/readonly.pp:18
  exec { "link $name to $target":
    command => "rm -rf $name && ln -fs $target $name",
    unless => "readlink $name | grep -q '^$target$'"
  }

  # file { $name:
  #   ensure => $target
  # }
}
