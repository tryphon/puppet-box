#!/usr/bin/env ruby

require 'rubygems'
require 'steto'

require 'syslog_logger'

module Steto

  @@logger = SyslogLogger.new('steto')
  def self.logger
    @@logger
  end

end

Steto.config do
  
end

Dir["/etc/steto/**/*.rb"].sort.each { |f| load f }

ARGV.each { |f| load f }

Steto.default_engine.check.report
