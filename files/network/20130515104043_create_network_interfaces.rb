class CreateNetworkInterfaces < Box::Config::Migration

  def up
    unless config[:network_interfaces]
      config[:network_interfaces] = [ {:id => "eth0", :method => "dhcp"}.merge(config.attributes("network")) ]
    end
  end

end
