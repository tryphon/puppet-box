class debian {
  if $operatingsystem == "Debian" {
    if versioncmp($operatingsystemrelease, "7.0") >= 0 {
      $release = "wheezy"
    } elsif versioncmp($operatingsystemrelease, "6.0") >= 0 {
      $release = "squeeze"
    } elsif versioncmp($operatingsystemrelease, "5.0") >= 0 {
      $release = "lenny"
    } else {
      fail("Can't detect debian release")
    }
  } else {
    $release = "none"
  }

  $lenny = $release ? {
    "lenny" => true,
    default => false
  }

  $squeeze = $release ? {
    "squeeze" => true,
    default => false
  }

  $wheezy = $release ? {
    "wheezy" => true,
    default => false
  }
}
