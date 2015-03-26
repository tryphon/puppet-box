# Syslog not available during puppet launch on boot
unless ENV["PUPPET_BOOT"]
  require 'syslog/logger'
  Box.logger = Syslog::Logger.new("box")
end

local_files = Dir["/etc/box/local.d/*"]
local_files << "/etc/box/local.rb" if File.readable? "/etc/box/local.rb"

local_files.each do |local_file|
  begin
    load local_file
  rescue Exception => e
    Box.logger.error "Can't load local file #{local_file}: #{e}"
  end
end
