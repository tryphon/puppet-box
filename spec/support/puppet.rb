require 'tmpdir'

class PuppetTemplate

  attr_accessor :template_file

  def initialize(template_file)
    @template_file = File.expand_path(template_file)
  end

  @@tmp_dir = "tmp/spec"
  cattr_accessor :tmp_dir

  def render(context = {}, options = {})
    options = { :ouptut => :array }.merge(options)

    render_checksum = Digest::SHA256.hexdigest(File.read(template_file) + context.to_s)

    FileUtils.mkdir_p tmp_dir
    output_file = File.expand_path("#{tmp_dir}/output-#{render_checksum}")

    unless File.exist? output_file
      tmp_puppet_file = "#{tmp_dir}/input-#{render_checksum}.pp"

      File.open(tmp_puppet_file, "w") do |f|
        context.each do |key, value|
          f.puts "$#{key} = #{value.inspect}" unless value.nil? or value.empty?
        end
        f.puts "file { '#{output_file}': content => template('#{template_file}')  }"
      end

      unless system "FACTERIGNORE=^/usr bundle exec puppet apply #{tmp_puppet_file} > /dev/null 2>&1"
        puts File.read(tmp_puppet_file)
        raise "puppet error"
      end
    end

    array_output = File.readlines(output_file).map(&:strip)
    case options[:output]
    when :stripped
      array_output.delete_if(&:empty?).join("\n") + "\n"
    else
      array_output
    end
  end

end
