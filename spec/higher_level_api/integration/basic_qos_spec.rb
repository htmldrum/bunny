require "spec_helper"

describe Bunny::Channel, "#prefetch" do
  let(:connection) do
    c = Bunny.new(:user => "bunny_gem", :password => "bunny_password", :vhost => "bunny_testbed")
    c.start
    c
  end

  after :each do
    connection.close
  end

  context "with a positive integer < 65535" do
    it "sets that prefetch level via basic.qos" do
      ch = connection.create_channel
      expect(ch.prefetch(10)).to be_instance_of(AMQ::Protocol::Basic::QosOk)
    end
  end

  context "with a positive integer > 65535" do
    it "raises an ArgumentError" do
      ch = connection.create_channel
      expect {
        ch.prefetch(100_000)
      }.to raise_error(ArgumentError)
    end
  end

  context "with a negative integer" do
    it "raises an ArgumentError" do
      ch = connection.create_channel
      expect {
        ch.prefetch(-2)
      }.to raise_error(ArgumentError)
    end
  end
end
