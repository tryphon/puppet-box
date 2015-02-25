class nagios::plugins {
  package { ['nagios-plugins-basic', 'nagios-plugins-standard']: }

  # Provides check_raid for example, required wheezy
  package { 'nagios-plugins-contrib': }
}
