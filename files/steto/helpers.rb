require 'yaml'
require 'facter'
require 'box'

class Object

  def blank?
    respond_to?(:empty?) ? empty? : !self
  end

  def present?
    !blank?
  end

end

class Numeric

  def megabytes
    self * 1024 * 1024
  end
  alias_method :megabyte, :megabytes

  def gigabytes
    self.megabytes * 1024
  end
  alias_method :gigabyte, :gigabytes

  def in_gigabytes
    self.to_f / 1.gigabyte
  end

  def in_megabytes
    self.to_f / 1.megabyte
  end

end

Steto.config do
  def process(process_name, name = nil)
    name ||= "#{process_name.gsub('-','_')}_process"
    nagios name, "check_procs", :critical => "1:", :command => process_name
  end

  def box
    Box.local
  end
end

class JSONReporter

  def report(checks)
    # Use by Box::Status.load
    File.open("/var/lib/steto/statuses.json", "w") do |file|
      file.write checks.to_json
    end

    # Published by apache on /status.json
    File.open("/var/lib/steto/status.json", "w") do |file|
      file.write Box.local.status.summary.to_json
    end
  end

end

Steto.config do
  report JSONReporter
end
