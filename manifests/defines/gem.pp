define ruby::gem($ensure = "installed") {
  include ruby::gems

  package { $name: 
    provider => gem, 
    ensure => $ensure,
    require => Package[rubygems] 
  }
}
