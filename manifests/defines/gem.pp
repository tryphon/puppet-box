define ruby::gem($ensure = "installed") {
  include ruby::gems

  package { $name:
    provider => gem,
    ensure => $ensure,
    require => [Exec[gem-source-tryphon], File["/etc/gemrc"]]
  }
}
