class linux::kernel-2-6-30 {
  include apt::backport
  if $debian::lenny {
    package { "linux-image-2.6-686":
      ensure => "2.6.32+27~bpo50+1",
      require => Apt::Source::Pin["linux-image-2.6-686"]
    }
	  package { "linux-image-2.6.26-2-686":
		  ensure => purged
	  }
    apt::source::pin { "linux-image-2.6-686":
      source => "lenny-backports"
    }
  }
}
