define ruby::gem($ensure = "installed") {
  include ruby::gems

  package { $name: 
    provider => gem, 
    ensure => $ensure,
    require => [Package[rubygems], Exec[gem-source-tryphon]]
    notify => Exec["rubygems-fix-date-format"]
  }
}
