#!/usr/bin/env ruby

require 'rubygems'
require 'steto'

begin
  require 'syslog/logger'
rescue LoadError
  require 'syslog_logger'
  module Syslog
    Logger = SyslogLogger
  end
end

module Steto

  @@logger = Syslog::Logger.new('steto')
  def self.logger
    @@logger
  end

end

Steto.config do
  
end

Dir["/etc/steto/**/*.rb"].sort.each { |f| load f }

ARGV.each { |f| load f }

Steto.default_engine.check.report
