ActionController::Routing::Routes.draw do |map|
  
  map.resources :topics, :member => {:vote => :post}
  
  map.root :controller => 'topics'
  
end
