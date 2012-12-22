Steto.config do

  check :box_release_latest_http do
    url = case box.name
          when "rivendellnasbox" 
            "/rivendellboxes/latest.yml"
          else 
            "/#{box.name}/latest.yml"
          end
    
    nagios_check = Steto::NagiosCheck.new :command => "/usr/lib/nagios/plugins/check_http", :options => { :host => "download.tryphon.eu", :url => url }

    # only returns a warning
    nagios_check.status.critical? ? :warning : nagios_check.status
  end

end
