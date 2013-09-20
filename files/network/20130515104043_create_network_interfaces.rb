class CreateNetworkInterfaces < Box::Config::Migration

  def up
    unless config[:network_interfaces]
      legacy_attributes = config.attributes("network").delete_if { |k,v| k.to_s =~ /^iface1/ || v == "" }
      config[:network_interfaces] = [ {:id => "eth0", :method => "dhcp"}.merge(legacy_attributes) ]
    end
  end

end
