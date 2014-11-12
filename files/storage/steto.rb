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

  def total_size
    unless @total_size
      total_block, block_size = `stat --file-system --printf="%b %S" #{mount_point}`.split.collect(&:to_i)
      @total_size = total_block*block_size
    end
    @total_size
  end

end

class StorageCheck

  attr_accessor :name, :warning_threshold, :critical_threshold

  def initialize(name, options = {})
    @name = name

    options = {
      :warning_threshold => '10%',
      :critical_threshold => '5%'
    }.merge(options)

    options.each do |k,v|
      send "#{k}=", v
    end
  end

  def path
    "/srv/#{name}"
  end

  def max_threshold(threshold, max_ratio)
    if threshold.to_s =~ /^[0-9]+$/
      threshold_size = threshold.to_i
      max_threshold_size = (mount_point.total_size.in_megabytes * max_ratio).to_i
      [max_threshold_size, threshold_size].min
    else
      threshold
    end
  end

  def warning_threshold
    max_threshold(@warning_threshold, 0.1)
  end

  def critical_threshold
    max_threshold(@critical_threshold, 0.05)
  end

  def mount_point
    MountPoint[path]
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

    config.nagios check_name(:free_space), "check_disk", :warning => warning_threshold, :critical => critical_threshold, :path => path
  end
end

Steto.config do
  def storage_raid?
    @storage_raid ||= Dir["/dev/md[0-9]*"].present?
  end

  if storage_raid?
    nagios :disks_raid, "check_raid"
  end
end
