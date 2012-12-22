class SyslogReporter
  attr_accessor :logger

  def logger
    @logger ||= Syslog::Logger.new("steto")
  end

  def report(checks)
    checks.each do |check|
      level = 
        case check.status
        when /warning|unknown/
          :warn 
        when "critical"
          :error
        end

      if level
        message = "#{check.name} is #{check.status}"
        message += ": #{check.text}" if check.text

        logger.send level, message
      end
    end
  end
end

Steto.config do
  report SyslogReporter
end
