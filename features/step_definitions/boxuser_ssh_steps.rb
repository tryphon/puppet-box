require 'net/ssh'

Then /^I can open an ssh session with boxuser$/ do
  private_key = File.expand_path("../test_rsa", __FILE__)
  Net::SSH.start(current_box.ip_address, 'boxuser', :keys => [private_key], :paranoid => false) do |ssh|
    ssh.exec!("/bin/true")
  end
end
