Then /^a process "([^"]*)" should be running$/ do |process_name|
  not current_box.ssh("pgrep '#{process_name}'").nil?
end

Then /^a process "([^"]*)" should not be running$/ do |process_name|
  current_box.ssh("pgrep '#{process_name}'").nil?
end

When /^the box reboots$/ do
  current_box.reboot
end

Then /^a file "([^"]*)" should exist$/ do |filename|
  expect(current_box.file(filename).exist?).to be_truthy
end

Then /^a directory "([^"]*)" should exist$/ do |name|
  expect(current_box.directory(name).exist?).to be_truthy
end

When /^the service "([^"]*)" is restarted$/ do |service|
  current_box.ssh("invoke-rc.d #{service} restart")
end

Then /^the box syslog is saved$/ do
  save_box_syslog
end
