When /I send "([^"]*)" in UDP on port ([0-9]+)$/ do |content, port|
  UDPSocket.new.send content, 0, current_box.ip_address, port
end
