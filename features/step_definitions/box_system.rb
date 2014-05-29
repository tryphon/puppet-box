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
  current_box.file(filename).exist?.should be_true
end

Then /^a directory "([^"]*)" should exist$/ do |name|
  current_box.directory(name).exist?.should be_true
end
