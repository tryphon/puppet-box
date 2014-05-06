class MountPoint

  def self.all
    @all ||= `mount`.scan(%r{([^ ]+) on ([^ ]+) type ([^ ]+) \(([^\(]+)\)}).map { |values| [[:device, :mount_point, :type, :options], values].transpose }.map { |pairs| Hash[pairs] }.map { |attributes| MountPoint.new attributes }
  end

  def self.find(directory)
    all.find { |m| m.mount_point == directory }
  end
  class << self
    alias_method :[], :find
  end

  def initialize(attributes = {})
    attributes.each { |k,v| send "#{k}=", v }
  end

  attr_accessor :device, :mount_point, :type, :options

  def options=(options)
    options = options.split(",") if String === options
    @options = options
  end

  def writable?
    options.include? "rw"
  end

end

class StorageCheck

  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def mount_point
    MountPoint["/srv/#{name}"]
  end

  def check_name(suffix)
    "storage_#{name}_#{suffix}".to_sym
  end

  def config(config)
    config.check check_name(:disk_by_label) do
      File.exists?("/dev/disk/by-label/#{name}") or mount_point.present?
    end

    config.check check_name(:fs_mounted) do
      mount_point.present?
    end

    config.check check_name(:fs_writable) do
      mount_point.writable? if mount_point
    end
  end
end

Steto.config do
  nagios "disks_free_space", "check_disk", :warning => '10%', :critical => '5%', :x => '/'

  def storage_raid?
    @storage_raid ||= Dir["/dev/md[0-9]*"].present?
  end

  if storage_raid?
    nagios :pige_raid, "check_linux_raid"
  end
end
