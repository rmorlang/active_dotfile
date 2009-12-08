require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class TestClass
  include ActiveDotfile
end

module ActiveDotfile
  class Base; end
end

describe "ActiveDotfile" do
  before do
    @configuration = mock("configuration")
    ActiveDotfile::Base.stub! :new => @configuration
  end
  
  describe "#configuration" do
    subject { TestClass.new }
    
    it "should return an instance of the configuration object" do
      subject.configuration.should == @configuration
    end

    it "should memoize the return value" do
      ActiveDotfile::Base.stub!(:new).and_return { @@number ||= 0; @@number += 1 }  
      subject.configuration.should == subject.configuration
    end

    it "should initialize the configuration object with the class name of the caller" do
      ActiveDotfile::Base.should_receive(:new).with("test_class")
      subject.configuration
    end
  end


end
