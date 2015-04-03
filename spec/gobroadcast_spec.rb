require 'spec_helper'

describe "GoBroadcast" do

  describe "migration CreateGoBroadcastStreams" do

    let(:config) { Box::PuppetConfiguration.new }
    let(:migration) { Box::Config::Migration.create File.expand_path("../../files/go-broadcast/migrations/20150401085239_create_go_broadcast_streams.rb", __FILE__) }

    let(:gobroadcast_config_file) { "tmp/go-broadcast.json" }
    let(:gobroadcast_config) { JSON.parse File.read(gobroadcast_config_file) }

    before do
      FileUtils.rm_f gobroadcast_config_file

      migration.gobroadcast_config_file = gobroadcast_config_file
      migration.config = config
    end

    it "should create GoBroadcast streams configuration with stream_... attributes" do
      config[:stream_1_id]="1"
      config[:stream_1_server_type]="icecast2"
      config[:stream_1_server]="stream-in.tryphon.eu"
      config[:stream_1_port]="8000"
      config[:stream_1_mount_point]="streambox.ogg"
      config[:stream_1_format]="vorbis"
      config[:stream_1_mode]="vbr"
      config[:stream_1_quality]="4"
      config[:stream_1_password]="secret"

      migration.up

      gobroadcast_config["Http"]["Streams"][0]["Identifier"].should == "1"
      gobroadcast_config["Http"]["Streams"][0]["Target"].should == "http://source:secret@stream-in.tryphon.eu:8000/streambox.ogg"
      gobroadcast_config["Http"]["Streams"][0]["Format"].should == "ogg/vorbis:vbr(q=4)"
      gobroadcast_config["Http"]["Streams"][0]["ServerType"].should == "icecast2"
    end

    describe "#create_stream" do

      it "should use id as Identifier" do
        migration.create_stream(id: "dummy")["Identifier"].should == "dummy"
      end

      it "should create ServerType from server_type" do
        migration.create_stream(server_type: "icecast2")["ServerType"].should == "icecast2"
        migration.create_stream(server_type: "shoutcast")["ServerType"].should == "shoutcast"
        migration.create_stream(server_type: "local")["ServerType"].should == "icecast2"
      end

      it "should create Target from password, server, port, mount_point" do
        migration.create_stream(password: "secret", secret: "stream-in.tryphon.eu", port: "8000", mount_point: "dummy")["Target"] == "http://source:secret@stream-in.tryphon.eu:8000/dummy"
      end

      it "should create Format from quality, bitrate and format attributes" do
        migration.create_stream(format: "vorbis", mode: "vbr", quality: "5")["Format"].should == "ogg/vorbis:vbr(q=5)"
        migration.create_stream(format: "mp3", mode: "cbr", bitrate: "160")["Format"].should == "mp3:cbr(b=160)"
        migration.create_stream(format: "aac", mode: "vbr")["Format"].should == "aac:vbr"
      end

      it "should not include Description when empty" do
        migration.create_stream["Description"].should be_nil
      end

      it "should include Description with present attributes" do
        migration.create_stream({ genre: "", name: "dummy"  })["Description"].should == { "Name" => "dummy" }
      end

    end

  end

end
