module TopicsHelper
  
  def vote_description(vote)
    "#{vote.irc_nick} voted for option <i>#{vote.choice.name}</i> on the topic #{link_to vote.topic.name, topic_url(vote.topic)}"
  end
  
  def vote_face(vote)
    unless vote.face.nil?
      image_tag vote.face, :alt => "#{vote.irc_nick}'s ugly face"
    else
      image_tag "no-face.png", :alt => "#{vote.irc_nick} is too slack to upload his face"
    end
  end
  
end
