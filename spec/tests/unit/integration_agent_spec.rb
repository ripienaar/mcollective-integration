#! /usr/bin/env ruby

require File.join([File.dirname(__FILE__), '../../spec_helper'])

RSpec.configure do |config|
  config.before :each do
    MCollective::PluginManager.clear
  end
end

describe "integration agent" do
  before do
    agent_file = File.join(File.dirname(__FILE__), "../../../agent/integration.rb")
    @agent = MCollective::Test::LocalAgentTest.new("integration", :agent_file => agent_file).plugin

    @agent.config.stubs(:pluginconf).returns({"integration.identity" => nil})
  end

  describe "#before_processing_hook" do
    it "should set reply[:data][:test_sender] to 'integration'" do
      result = @agent.call(:echo, :msg => "foo")
      result.should have_data_items(:test_sender)
    end
  end

  describe "#after_processing_hook" do
    it "should set reply[:data][:post_sender] to 'integration'" do
      result = @agent.call(:echo, :msg => "foo")
      result.should have_data_items(:post_sender)
    end
  end

  describe "#echo" do
    it "should echo msg string" do
      result = @agent.call(:echo, :msg => "echo")
      result.should be_successful
      result[:data][:message].should == "echo"
    end
  end

  describe "#validation" do
    it "should be successful if msg is validate" do
      result = @agent.call(:validation, :msg => "validate")
      result.should be_successful
      result[:data][:passed].should == 1
    end

    # commenting out as the mcollective-test mocks validation as ppl should
    # now use DDLs to validate
    #it "should fail if message is not validate" do
    #  result = @agent.call(:validation, :msg => 1)
    #  result.should be_invalid_data_error
    #end
  end

  describe "#soft_fail" do
    it "should fail and set reply[:message] to 'Soft Failure'" do
      result = @agent.call(:soft_fail)
      result.should be_aborted_error
      result[:data][:message].should == "Soft Failure"
    end
  end

  describe "#hard_fail" do
    it "should fail and not set reply[:messag] to 'Hard Failure'" do
      result = @agent.call(:hard_fail)
      result.should be_aborted_error
      result[:data][:message].should == nil
    end
  end
end
