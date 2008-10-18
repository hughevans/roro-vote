class Vote < ActiveRecord::Base
  
  belongs_to :topic
  belongs_to :choice

  validates_presence_of   :choice,
                          :message => "^You forgot to make a selection"

  validates_presence_of   :irc_nick, 
                          :on => :create,
                          :message => "^IRC nick can't be blank"

  validates_presence_of   :user_id,
                          :message => "^Your IRC nick could not be found on faces.rubyonrails.com.au"
  
  validates_uniqueness_of_set :choice_id, :user_id, :topic_id,
                          :message  => "^You have already voted for this choice on this topic (or possibly some punk has for you)"
  
  attr_accessor :user
  
  before_validation_on_create :find_user, :set_user_id, :set_face
  
  attr_accessible :choice_id, :irc_nick
  
  def self.paged_votes(page)
    paginate :order => 'votes.created_at DESC', :page => page, :per_page => 7, :include => {:choice, :topic}
  end
  
  protected
  
  def find_user
    self.user = User.find_from_irc_nick(irc_nick) unless irc_nick.nil?
  end
  
  def set_user_id
    self.user_id = user.id unless user.nil?
  end
  
  def set_face
    unless user.nil? || user.mugshot.nil?
      self.face = "http://faces.rubyonrails.com.au/mugshots/#{user.mugshot.id}/#{user.mugshot.thumbnail_filename}"
    end
  end
  
end
