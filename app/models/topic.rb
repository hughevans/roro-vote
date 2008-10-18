class Topic < ActiveRecord::Base
  
  has_many :choices
  has_many :votes
  
  validates_presence_of :name, :description
  
  def paged_votes(page)
    votes.paginate :order => 'votes.created_at DESC', :page => page, :per_page => 7, :include => :choice
  end
  
  def disable!
    self.enabled = false
  end
  
end
