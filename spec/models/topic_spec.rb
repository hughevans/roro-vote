require File.dirname(__FILE__) + '/../spec_helper'

describe Topic do
  
  before(:each) do
    @topic = Topic.new
  end
  
  it "should be valid with a name and description" do
    @topic.name = 'Topic 1'
    @topic.description = 'All about topic 1'
    @topic.should be_valid
  end

  it "should validate the pressence of a name" do
    @topic.should validate_presence_of(:name)
  end
  
  it "should validate the pressence of a description" do
    @topic.should validate_presence_of(:description)
  end
  
  it "should have many choices" do
    @topic.should have_many(:choices)
  end
  
  it "should have many votes" do
    @topic.should have_many(:votes)
  end
  
  it "should be enabled by default" do
    @topic.enabled.should == true
  end
  
  it "should have a 'disable!' method" do
    @topic.disable!
    @topic.enabled.should == false
  end
  
end