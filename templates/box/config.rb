require 'syslog/logger'
Box.logger = Syslog::Logger.new("box")

local_files = Dir["/etc/box/local.d/*"]
local_files << "/etc/box/local.rb"

local_files.each do |local_file| 
  begin
    load local_file
  rescue => e
    Box.logger.error "Can't load local file #{local_file}: #{e}"
  end
end
