Rails.application.routes.draw do
  resources :users, param: :_username
   post '/user/following_users', to: 'users#following_users'
   resources :tweets
   post '/tweet/followed_tweets', to: 'tweets#followed_tweets'
   post '/tweet/own_tweets', to: 'tweets#own_tweets'
  post '/auth/login', to: 'authentication#login'
  #get '/*a', to: 'application#not_found'
  post '/follow/following', to: 'follows#following'
  post '/follow/unfollow', to: 'follows#unfollow'
  get  '/follow/get_follows', to: 'follows#get_follows'
end