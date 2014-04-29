require 'spec_helper'

describe "Alsa" do

  describe "asound.conf" do

    let(:alsa_config) { Hash.new }

    let(:output) do
      PuppetTemplate.new("files/alsa/asound.conf").render(:alsa_config => alsa_config)
    end

    def normalize(output)
      output.map!(&:strip).delete_if(&:empty?).join("\n") + "\n"
    end

    it "should render single entry" do
      alsa_config["pcm.rd0"] = { "type" => "plug", "slave.pcm" => "hw:0" }
      normalize(output).should == <<-EOF
pcm.rd0 {
type plug
slave.pcm hw:0
}
      EOF
    end

    it "should render multi entries" do
      alsa_config["pcm.rd0"] = { "type" => "plug", "slave.pcm" => "hw:0" }
      alsa_config["ctl.rd0"] = { "type" => "hw", "card" => "0" }
      normalize(output).should == <<-EOF
pcm.rd0 {
type plug
slave.pcm hw:0
}
ctl.rd0 {
type hw
card 0
}
      EOF
    end

  end

end
