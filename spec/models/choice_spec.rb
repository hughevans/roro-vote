require File.dirname(__FILE__) + '/../spec_helper'

describe Choice do
  
  before(:each) do
    @choice = Choice.new
  end

  it "should validate the pressence of a name" do
    @choice.should validate_presence_of(:name)
  end

  it "should validate the pressence of the topic" do
    @choice.should validate_presence_of(:topic)
  end
  
  it "should belong to a topic" do
    @choice.should belong_to(:topic)
  end
  
end
