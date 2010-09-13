#!/usr/bin/env ruby

require 'optparse'

OptionParser.new do |opts|
  opts.banner = <<-BANNER.gsub(/^    /,'')
    Storage : manage box storage

    Usage: #{File.basename($0)} [options] [target]

    Options are:
    BANNER
  opts.separator ""
  opts.on("-l", "--label=LABEL", String,
          "Label for the created filesystem") { |arg| @label = arg }
  opts.on("-h", "--help",
          "Show this help message.") { puts opts; exit }
  opts.parse!(ARGV)
  
  @command = ARGV.shift
  
  unless @label and @command == "init"
    puts opts; exit
  end
end

unless Process.uid == 0
  puts "You must be root to initialize the storage"
  exit 1
end

if File.exists?("/dev/disk/by-label/#{@label}")
  puts "Disk with label #{@label} exists"
  exit 0
end

partitions = IO.read("/proc/partitions")

blank_disk = partitions.scan(/[hs]d[abcd]$/).detect do |device|
  partitions.grep(/#{device}[1-9]/).empty? and 
    `sfdisk -l /dev/#{device} 2>&1`.include?("No partitions found")
end

unless blank_disk
  puts "No blank disk detected"
  exit 1
end

puts "Prepare #{blank_disk} for storage"

disk_device = "/dev/#{blank_disk}"
partition_device = "#{disk_device}1"

partition_command = "echo '1,,L,' | /sbin/sfdisk -uS #{disk_device}"
fs_command = "mke2fs -j -m 0 -L #{@label} #{partition_device}"

command = [partition_command, fs_command].join(' && ')
puts "Run: #{command}"
exit 1 unless system command


