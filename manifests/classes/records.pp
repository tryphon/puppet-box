class records {
  include records::munin
}

class records::munin {
  include munin::ruby
  include sox::ruby

  munin::plugin { last_record_levels:
    source => "puppet:///box/records/munin/last_file_levels",
    config => "timeout 20\nuser root"
  }
}
