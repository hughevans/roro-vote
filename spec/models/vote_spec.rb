require File.dirname(__FILE__) + '/../spec_helper'

module VoteSpecHelper
  
  def valid_vote_attributes
    {
      :choice_id => choices(:topic_one_choice_one).id,
      :irc_nick  => '_matta_'
    }
  end
  
end

describe Vote do
  
  fixtures :topics, :choices, :votes
  
  include VoteSpecHelper
  
  include UsersXmlMock
  
  before(:each) do
    setup_users_xml_mock
    @vote = topics(:topic_one).votes.build
  end
  
  it "should be valid with valid attributes" do
    @vote.attributes = valid_vote_attributes
    @vote.should be_valid
  end
  
  it "should belong to a topic" do
    @vote.should belong_to(:topic)
  end
  
  it "should belong to a choice" do
    @vote.should belong_to(:choice)
  end
  
  it "should validate the pressence of the choice" do
    @vote.should validate_presence_of(:choice)
  end
  
  it "should validate the pressence of an irc_nick" do
    @vote.should validate_presence_of(:irc_nick)
  end
  
  it "should not be valid if user's irc_nick is not found" do
    @vote.attributes = valid_vote_attributes.with(:irc_nick => 'qqq')
    @vote.should_not be_valid
  end
  
  it "should not be valid if user has already voted with the choice on the topic" do
    @vote.attributes = valid_vote_attributes.with(:irc_nick => 'lachie')
    @vote.should be_valid
    @vote.user_id.should == 1
    @vote.save
    
    @vote = topics(:topic_one).votes.build
    @vote.attributes = valid_vote_attributes.with(:irc_nick => 'lachie')
    @vote.should have_at_least(1).error_on(:choice_id)
  end
  
  it "should ve valid if the user has already voted for a different choice" do
    @vote.attributes = valid_vote_attributes.merge(
      :irc_nick => "lachie",
      :choice_id => choices(:topic_one_choice_two).id
    )
    @vote.should be_valid
  end
  
  it "should have set the face from the user's faces profile if they have a mugshot" do
    @vote.attributes = valid_vote_attributes
    @vote.should be_valid
    @vote.face.should == 'http://faces.rubyonrails.com.au/mugshots/35/rbbq-avatar-large_thumb.png'
  end
  
  it "should not have set the face from the user's faces profile if they don't have a mugshot" do
    @vote.attributes = valid_vote_attributes.with(:irc_nick => 'chris')
    @vote.should be_valid
    @vote.face.should be_nil
  end
  
  describe "from fixture 'topic_two_vote_one'" do
    
    before(:each) do
      @vote = votes(:topic_two_vote_one)
    end
    
    it "should be valid" do
      @vote.should be_valid
    end
    
  end
  
end