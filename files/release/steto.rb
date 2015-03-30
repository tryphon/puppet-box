Steto.config do

  check :box_release_latest_http do
    nagios_check = Steto::NagiosCheck.new :command => "/usr/lib/nagios/plugins/check_http", :options => { :host => "download.tryphon.eu", :url => box.type.latest_url }
    # only returns a warning
    nagios_check.status.critical? ? :warning : nagios_check.status
  end

end
