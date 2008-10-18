class User < ActiveResource::Base 

  self.site = 'http://faces.rubyonrails.com.au'
  
  def self.find_from_irc_nick(nick)
    u = nil
    find(:all).each {|user| u = user if user.irc_nick == nick}
    return u
  end
    
end