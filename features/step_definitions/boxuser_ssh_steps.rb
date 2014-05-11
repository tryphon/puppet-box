require 'net/ssh'
require 'sshkey'

Then /^I can open an ssh session with boxuser$/ do
  Net::SSH.start(current_box.ip_address, 'boxuser', :key_data => [@ssh_key.private_key], :paranoid => false, :logger => Logger.new("log/ssh.log")) do |ssh|
    ssh.exec!("/bin/true")
  end
end

Given /^I create an ssh key$/ do
  @ssh_key = SSHKey.generate
end

When /^I register this ssh key in authorized keys$/ do
  visit '/ssh'
  click_link 'Edit'
  fill_in 'Authorized keys', :with => @ssh_key.ssh_public_key
  click_button 'Save'
end
