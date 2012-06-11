Steto.config do
  process "proftpd"

  nagios :ftp_server, "check_ftp", :hostname => "localhost"
end
