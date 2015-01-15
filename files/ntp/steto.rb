Steto.config do
  def ntp_server
    box.config['ntp_server'] or "pool.ntp.org"
  end

  nagios :ntp_time, :check_ntp_time, :host => ntp_server
  # nagios :ntp_peers, :check_ntpd, :peer_critical => 0, :peer_warning => 0, :critical => 0, :warning => 10
end
