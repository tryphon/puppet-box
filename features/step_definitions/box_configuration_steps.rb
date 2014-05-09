Given /^the box configuration contains ([a-z_]+) = "([^"]*)"$/ do |key, value|
  current_box.configuration do |config|
    config[key] = value
    config.save
  end
end

Given /^the box configuration doesn't contain ([a-z_]+)$/ do |key|
  current_box.configuration do |config|
    config.delete key
    config.save
  end
end

When /^the configuration is applied$/ do
  current_box.configuration.deploy!
end

Given /^the box configuration is saved$/ do
  current_box.configuration.persist!
end
