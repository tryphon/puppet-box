Steto.config do
  nagios :ntp_time, :check_ntp_time, :host => "#{rand(4)}.debian.pool.ntp.org"
end
