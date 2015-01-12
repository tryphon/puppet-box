Steto.config do
  def ntp_server
    box.config['ntp_server'] or "pool.ntp.org"
  end

  nagios :ntp_time, :check_ntp_time, :host => ntp_server
end
