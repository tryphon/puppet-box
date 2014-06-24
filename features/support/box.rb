require 'open-uri'
require 'fileutils'
require 'vmbox'

I18n.enforce_available_locales = false
require 'active_support/core_ext/string/inflections'

Before do |scenario|
  @scenario_name = scenario.name
  # Could use scenario file basename as prefix
  @scenario_key = scenario.name.parameterize
end

Before do
  Capybara.app_host = current_box.url
end

def before_rollback(&block)
  (@before_rollback_callbacks ||= []) << block
end

def save_box_syslog
  open(current_box.url("log.gz"), "rb") do |read_file|
    File.open("log/cucumber-syslog-#{Time.now.to_i}-#{@scenario_key}.gz", "wb") do |saved_file|
      FileUtils.copy_stream read_file, saved_file
    end
  end
end

After do |scenario|
  save_box_syslog if scenario.failed?

  @before_rollback_callbacks.each do |hook|
    hook.call scenario
  end if @before_rollback_callbacks

  retry_count = 0
  begin
    current_box.rollback
  rescue Timeout::Error => e
    retry_count += 1
    VMBox.logger.error "Rollback failed : #{e}"
    if retry_count < 10
      retry
    else
      VMBox.logger.error "Stop tests"
      Cucumber.wants_to_quit = true
    end
  end
end
