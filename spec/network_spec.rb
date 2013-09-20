require 'spec_helper'

describe "Network" do

  describe "interfaces" do

    def render
      output_file = File.expand_path("#{tmp_dir}/output")
      template_file = File.expand_path("files/network/interfaces")

      tmp_puppet_file = "#{tmp_dir}/test.pp"
      File.open(tmp_puppet_file, "w") do |f|
        f.puts "$network_interfaces = #{network_interfaces.inspect}" unless network_interfaces.empty?
        f.puts "file { '#{output_file}': content => template('#{template_file}')  }"
      end

      unless system "FACTERIGNORE=^/usr bundle exec puppet apply #{tmp_puppet_file} > /dev/null"
        puts File.read(tmp_puppet_file)
        raise "puppet error"
      end

      File.readlines(output_file).map(&:strip)
    end

    let(:network_interfaces) { [] }

    let(:output) do
      render
    end

    let(:tmp_dir) { "tmp/spec" }

    before do
      FileUtils.mkdir_p tmp_dir
    end

    after do
      FileUtils.rm_rf tmp_dir
    end

    it "should define lo" do
      output.should include("auto lo")
      output.should include("iface lo inet loopback")
    end

    it "should define eth0 by default" do
      output.should include("auto eth0")
      output.should include("iface eth0 inet dhcp")
    end

    context "when network_interfaces is defined" do

      it "should define iface for each entry" do
        network_interfaces << { "id" => "eth0", "method" => "dhcp" }
        network_interfaces << { "id" => "eth1", "method" => "dhcp" }

        output.should include("auto eth0")
        output.should include("iface eth0 inet dhcp")

        output.should include("auto eth1")
        output.should include("iface eth1 inet dhcp")
      end

      it "should use method in 'iface xyz inet ...'" do
        network_interfaces << { "id" => "eth0", "method" => "dummy" }
        output.should include("iface eth0 inet dummy")
      end

      it "should use ignore blank attribute" do
        network_interfaces << { "id" => "eth0", "method" => "static" }
        output.should_not include("address")
        output.should_not include("gateway")
        output.should_not include("network")
        output.should_not include("dns-nameservers")
      end

      it "should include a wpa-conf entry when interface is wlan*" do
        network_interfaces << { "id" => "wlan0" }
        output.should include("wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf")
      end

      it "should include a 'vlan_raw_device' entry when interface is vlan*" do
        network_interfaces << { "id" => "vlan100" }
        output.should include("vlan_raw_device eth0")
      end

      it "should use raw_device entry when interface is vlan*" do
        network_interfaces << { "id" => "vlan100", "raw_device" => "eth1" }
        output.should include("vlan_raw_device eth1")
      end

      it "should include iptables nat rule when interface has options nat" do
        network_interfaces << { "id" => "eth0", "options" => "nat" }
        output.should include("up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE")
      end

      it "should include routes when defined in interface" do
        network_interfaces << { "id" => "eth0", "routes" => [ "8.8.8.8 via 192.168.1.1" ] }
        output.should include("up ip route add 8.8.8.8 via 192.168.1.1")
      end

      context "and method is static" do

        let(:network_interface) do
          { "id" => "eth0" }.tap do |interface|
            network_interfaces << interface
          end
        end

        before do
          network_interface["method"] = "static"
        end

        it "should use static in 'iface xyz inet ...'" do
          output.should include("iface eth0 inet static")
        end

        it "should use static_address" do
          network_interface["static_address"] = "192.168.1.10"
          output.should include("address 192.168.1.10")
        end

        it "should use static_netmask" do
          network_interface["static_netmask"] = "255.255.255.0"
          output.should include("netmask 255.255.255.0")
        end

        it "should use static_gateway" do
          network_interface["static_gateway"] = "192.168.1.1"
          output.should include("gateway 192.168.1.1")
        end

        it "should use static_dns1 when defined" do
          network_interface["static_dns1"] = "8.8.8.8"
          output.should include("dns-nameservers 8.8.8.8")
        end

        it "should use static_dns2 when defined" do
          network_interface["static_dns1"] = "8.8.8.8"
          network_interface["static_dns2"] = "8.8.4.4"
          output.should include("dns-nameservers 8.8.8.8 8.8.4.4")
        end

      end

    end

  end


  describe "migration CreateNetworkInterfaces" do

    let(:config) { Box::PuppetConfiguration.new }
    let(:migration) { Box::Config::Migration.create "files/network/20130515104043_create_network_interfaces.rb" }

    before do
      migration.config = config
    end

    it "should create network_interfaces eth0 with network_... attributes" do
      config[:network_method]="dhcp"
      config[:network_static_address]="192.168.1.2"
      config[:network_static_netmask]="255.255.255.0"
      config[:network_static_gateway]="192.168.1.1"
      config[:network_static_dns1]="192.168.1.1"

      migration.up

      config[:network_interfaces].should ==
        [
         { "id" => "eth0",
           "method" => "dhcp",
           "static_address" => "192.168.1.2",
           "static_netmask" => "255.255.255.0",
           "static_gateway" => "192.168.1.1",
           "static_dns1" => "192.168.1.1"
         }
        ]
    end

    it "should not change network_interfaces if exists" do
      config[:network_interfaces] = [ { :id => "dummy" } ]
      lambda { migration.up }.should_not change { config[:network_interfaces] }
    end

    it "should create a default network_interfaces if network_ attributes don't exist" do
      migration.up
      config[:network_interfaces].should == [ { "id" => "eth0", "method" => "dhcp" } ]
    end

    it "shoud ignore network_iface1 attributes" do
      config[:network_method]="dhcp"
      config[:iface1_network_method]="dhcp"

      migration.up

      config[:network_interfaces].should == [ { "id" => "eth0", "method" => "dhcp" } ]
    end

    it "shoud ignore empty value" do
      config[:network_method]="dhcp"
      config[:network_static_gateway]=""

      migration.up

      config[:network_interfaces].should == [ { "id" => "eth0", "method" => "dhcp" } ]
    end

  end

end
