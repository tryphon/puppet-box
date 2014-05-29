I18n.enforce_available_locales = false
require 'active_support/core_ext/string/inflections'

Before do |scenario|
  @scenario_name = scenario.name
  # Could use scenario file basename as prefix
  @scenario_key = scenario.name.parameterize
end
