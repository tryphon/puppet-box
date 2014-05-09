Then /^a process "([^"]*)" should be running$/ do |process_name|
  not current_box.ssh("pgrep '#{process_name}'").nil?
end

Then /^a process "([^"]*)" should not be running$/ do |process_name|
  current_box.ssh("pgrep '#{process_name}'").nil?
end

When /^the box reboots$/ do
  current_box.reboot
end
