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

class Storage

  attr_reader :label

  def initialize(label)
    @label = label
  end

  def exist?
    File.exists?("/dev/disk/by-label/#{@label}")    
  end

  def devices
    IO.read("/proc/partitions").scan(/[hs]d[abcd][1-9]*$/).collect { |p| "/dev/#{p}" }
  end

  def disks
    devices.grep(/[^1-9]$/)
  end

  def partitions(device = "")
    devices.grep(/#{device}[1-9]$/)
  end

  def blank_disks
    disks.select do |disk|
      partitions(disk).empty? and 
        `sfdisk -l #{disk} 2>&1`.include?("No partitions found")
    end
  end

  def log(message)
    puts message
  end

  def check
    if File.exists?("/dev/disk/by-label/#{@label}")
      log "Disk with label #{@label} exists"
      check_raid1
    else
      create
    end
  end

  def create
    case blank_disks.size
    when 0
      log "No blank disk detected"
      false
    when 1
      create_simple
    else
      create_raid1
    end
  end

  def create_simple
    disk_device = blank_disks.first
    log "Prepare #{disk_device} for storage"

    execute do |c|
      partition = c.create_partition disk_device
      c.make2fs partition, label
    end
  end

  def create_raid1
    disk_devices = blank_disks.first(2)
    log "Prepare #{disk_devices} for raid storage"

    execute do |c|
      partitions = c.create_partitions disk_devices, "fd"
      c.push "mdadm -C /dev/md0 -l 1 --raid-device=2 #{partitions.join(' ')}"
      c.make2fs "/dev/md0", label
    end
  end

  def check_raid1
    return unless raid_degraded?

    disk_device = blank_disks.first
    unless disk_device
      log "Raid is degraded and no blank disk is available"
      return false
    end

    log "Insert #{disk_device} into raid storage"

    execute do |c|
      partition = c.create_partition disk_device, "fd"
      c.push "mdadm --manage /dev/md0 --add #{partition}"
    end
  end
  
  def raid_degraded?
    degraded_sys_file = "/sys/devices/virtual/block/md0/md/degraded"
    File.exists?(degraded_sys_file) and IO.read(degraded_sys_file).to_i == 1
  end

  def execute(&block)
    CommandBuilder.new.tap do |builder|
      yield builder
    end.execute
  end

  class CommandBuilder

    def initialize
      @command_parts = []
    end

    def create_partition(disk, type = "L")
      create_partitions([disk], type).first
    end

    def create_partitions(disks, type = "L")
      disks.collect do |disk|
        push "echo '1,,#{type},' | /sbin/sfdisk -uS #{disk}"
        "#{disk}1"
      end
    end

    def make2fs(partition, label)
      push "mke2fs -j -m 0 -L #{label} #{partition}"
    end

    def push(command)
      @command_parts << command
    end

    def command
      @command_parts.join(' && ')
    end

    def execute
      puts "Run: #{command}"
      system command
    end

  end


end

exit (Storage.new(@label).check ? 0 : 1)
