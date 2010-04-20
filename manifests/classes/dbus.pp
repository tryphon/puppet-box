class dbus::readonly {
  include readonly::common
  readonly::mount_tmpfs { "/var/lib/dbus": }
}
