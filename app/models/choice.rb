class Choice < ActiveRecord::Base
  
  belongs_to :topic
  
  validates_presence_of :name,
                        :topic
  
end
