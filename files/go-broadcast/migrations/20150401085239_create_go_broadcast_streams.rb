class CreateGoBroadcastStreams < Box::Config::Migration

  @@gobroadcast_config_file = "/var/etc/go-broadcast/config.json"
  cattr_accessor :gobroadcast_config_file

  def gobroadcast_config
    JSON.parse File.read(gobroadcast_config_file) rescue {}
  end

  def up
    return unless gobroadcast_config.empty?

    gobroadcast_streams = []

    (1..4).each do |stream_id|
      attributes = config.attributes("stream_#{stream_id}")
      unless attributes.empty?
        gobroadcast_streams << create_stream(attributes)
      end
    end

    unless gobroadcast_streams.empty?
      saved_config = { "Http" => { "Streams" => gobroadcast_streams } }
      Box.logger.info "Save new go-broadcast config : #{saved_config.inspect}"

      FileUtils.mkdir_p File.dirname(gobroadcast_config_file)
      File.write gobroadcast_config_file, saved_config.to_json
    end
  end

  def create_stream(attributes = {})
    format = [].tap do |parts|
      parts << (attributes[:format] == "vorbis" ? "ogg/vorbis" : attributes[:format])

      mode_attributes = {
        b: attributes[:bitrate],
        q: attributes[:quality]
      }.map { |k,v| "#{k}=#{v}" if v.present? }.compact.join(',')
      mode_attributes = "(#{mode_attributes})" if mode_attributes.present?

      parts << "#{attributes[:mode]}#{mode_attributes}"
    end.join(':')

    {
      "Identifier" => attributes[:id],
      "Target" => "http://source:#{attributes[:password]}@#{attributes[:server]}:#{attributes[:port]}/#{attributes[:mount_point]}",
      "Format" => format,
      "ServerType" => (attributes[:server_type] == "shoutcast" ? "shoutcast" : "icecast2")
    }.tap do |stream|
      description = {
        "Name" => attributes[:name],
		    "Description" => attributes[:description],
		    "URL" => attributes[:related_url],
		    "Genre" => attributes[:genre]
      }
      description.delete_if { |_,v| v.blank? }
      stream["Description"] = description unless description.empty?
    end
  end

end
