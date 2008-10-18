require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  
  include UsersXmlMock

  before(:each) do
    setup_users_xml_mock
  end
  
  it "should find the id for 'lachie' from the remote fixtures" do
    user = User.find_from_irc_nick('lachie')
    user.id.should == 1
  end
  
  it "should find the id for '_matta_' from the remote fixtures" do
    user = User.find_from_irc_nick('_matta_')
    user.id.should == 4
  end
  
  it "should return nil for the fake irc_nick of 'qqq'" do
    user = User.find_from_irc_nick('qqq')
    user.should be_nil
  end

end