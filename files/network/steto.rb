Steto.config do
  check :network_interface_ipaddress do
    Facter.value("ipaddress").present?
  end

  process "ifplugd"
end
