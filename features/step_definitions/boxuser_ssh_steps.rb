require 'net/ssh'
require 'sshkey'

def boxuser_test_ssh
  Net::SSH.start(current_box.ip_address, 'boxuser', :key_data => [@ssh_key.private_key], :paranoid => false, :logger => Logger.new("log/ssh.log"), :auth_methods => ["publickey"]) do |ssh|
    ssh.exec!("/bin/true")
  end
end

Then /^I can open a ssh session with boxuser$/ do
  boxuser_test_ssh
end

Then /^I can't open a ssh session with boxuser$/ do
  expect { boxuser_test_ssh }.to raise_error(Net::SSH::AuthenticationFailed)
end

Given /^I create a ssh key$/ do
  @ssh_key = SSHKey.generate
end

When /^I register this ssh key in authorized keys$/ do
  visit '/ssh'
  click_link 'Edit'
  fill_in 'Authorized keys', :with => @ssh_key.ssh_public_key
  click_button 'Save'
end

When /^I unregister all ssh keys$/ do
  visit '/ssh'
  click_link 'Edit'
  fill_in 'Authorized keys', :with => ''
  click_button 'Save'
end
