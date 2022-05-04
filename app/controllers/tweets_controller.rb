class TweetsController < ApplicationController

 before_action :authorize_request

 def index
 	@teewts = Tweet.all
    render json: @teewts, status: :ok
 end

	def create
		user = User.find_by_id(params[:user_id])
		if !user.nil?
	@tweet = Tweet.new(tweet_params)
    if @tweet.save
      render json: @tweet, status: :created
    else
      render json: { errors: @tweet.errors.full_messages },
             status: :unprocessable_entity
    end
else
	 render json: "oes not exits User d"
end
  end

  def own_tweets
  	user_name = User.where("name = ?",params[:name])
  	puts"====user_name====="+user_name.pluck(:id)[0].inspect
	if !user_name.blank?
	 user_follower_tweets = Tweet.where("user_id IN(?)", user_name.pluck(:id)[0]).order('created_at DESC')
    render json: user_follower_tweets
else
	render json: "this user doed not exits"
end
  end

def followed_tweets
	user_name = User.where("name = ?",params[:name])
	puts"====user_name====="+user_name.pluck(:id)[0].inspect
	if !user_name.blank?
	user = Follow.where("user_id = ?",user_name.pluck(:id)[0])
	following_id = user.pluck(:following_id)
	 user_follower_tweets = Tweet.where("user_id IN(?)", following_id).order('created_at DESC')
   render json: user_follower_tweets
else
	render json: "this user doed not exits"
end
end


  private
  def tweet_params
    params.permit(
      :user_id, :post
    )
  end
end
