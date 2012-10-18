Steto.config do
  process "apache2"

  nagios "apache2_http", "check_http", :host => "127.0.0.1"
end
