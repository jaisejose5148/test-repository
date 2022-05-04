class FollowsController < ApplicationController
	before_action :authorize_request

def get_follows
	@following_lists = Follow.all
	render json: @following_lists
end	

def unfollow
	user_main_id = User.find_by_id(params[:user_id])
  user_following_id = User.find_by_id(params[:following_id])

  if !user_main_id.blank? && !user_following_id.blank?
  	 unfollow_the_users
  else
  	render json: "no user exits"
  end
end

def unfollow_the_users
				@follows = Follow.where("user_id = ? and following_id = ?",params[:user_id],params[:following_id])
		puts"==========follow====="+@follows.inspect
     if !@follows.blank?

     	id = @follows.pluck(:id)
     	@finted = Follow.find(id)
     	@finted.destroy
     	 #@status = Follow.destroy.where(id: @follows.id)
     	 #@follows.destroy#.where(id: @follows.id.to_i)
		 render json: @finted
else
	 render json: "id"
end
end

def following
  user_main_id = User.find_by_id(params[:user_id])
  user_following_id = User.find_by_id(params[:following_id])

  if !user_main_id.blank? && !user_following_id.blank?
  	 entering_to_follow
  else
  	render json: "no user exits"
  end
	end
def entering_to_follow
			@follows = Follow.where("user_id = ? and following_id = ?",params[:user_id],params[:following_id])
		puts"==========follow====="+@follows.inspect
     if @follows.blank?
		@follow = Follow.new(follow_params)
		if @follow.save
      render json: @follow, status: :created
    else
      render json: { errors: @follow.errors.full_messages },
             status: :unprocessable_entity
    end
else
	 render json: "it is already following"
end
end

	private
	 def follow_params
    params.permit(
      :user_id,:following_id
    )
  end
end
