define pipe($owner = "root") {
  exec { "pipe-mkfifo-$name":
    command => "mkfifo $name && chown $owner $name",
    creates => "$name"
  }
}
