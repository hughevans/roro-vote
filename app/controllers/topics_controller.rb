class TopicsController < ApplicationController

  # GET /topics
  # GET /topics.xml  
  def index
    @topics = Topic.find :all
    @votes = Vote.paged_votes(params[:page])
    
    respond_to do |format|
      format.html # index.haml
      format.js   { render :partial => 'votes' }
      format.xml  { render :xml     => @topics }
    end
  end

  # GET /topics/1
  # GET /topics/1.xml
  def show
    @topics = Topic.find :all
    @topic = Topic.find(params[:id])
    @votes = @topic.paged_votes(params[:page])

    respond_to do |format|
      format.html # show.haml
      format.js   { render :partial => 'votes' }
      format.xml  { render :xml => @topic }
      format.results {
        bar = BarFade.new(55,'#333333')
        labels = []
        @topic.votes.count(:group => "choice_id").each do |t|
          labels << Choice.find(t[0]).name
          bar.data << t[1]
        end

        g = Graph.new
        g.title("Results ", '{font-size:20px; color: #333333; margin:10px; padding: 5px 15px 5px 15px;}' )
        g.set_bg_color('#fdfdfd')
        g.data_sets << bar

        g.set_x_axis_color('#e0e0e0', '#e0e0e0')
        g.set_x_tick_size(9)
        g.set_y_axis_color('#e0e0e0', '#e0e0e0')
        g.set_x_labels(labels)
        g.set_x_label_style(11,'#303030')
        g.set_y_label_style(11,'#303030')
        g.set_y_max(bar.data.max + 5)
        g.set_y_label_steps(5)
        render :text => g.render
      }
    end
  end
  
  def vote
    @topics = Topic.find :all
    @topic = Topic.find(params[:id])
    @votes = @topic.paged_votes(params[:page])
    @vote = @topic.votes.build(params[:vote])
    if @vote.save
      flash[:notice] = 'Thanks for voting'
      redirect_to topic_path(@topic)
    else
      render :action => :show, :id => @topic.id
    end
  end
  
end
