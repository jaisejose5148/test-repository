class UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create index following_users]
  after_action :create_user_api_token, only: [:create]

  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  def following_users
  	user_name = User.where("name = ?",params[:name])
  	puts"====user_name====="+user_name.pluck(:id)[0].inspect
	if !user_name.blank?
	 following_users = Follow.where("user_id IN(?)", user_name.pluck(:id)[0]).order('created_at DESC')
    render json: following_users
else
	render json: "this user doed not exits"
end
  end

  # GET /users/{username}
  def show
    render json: @user, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /users/{username}
  def update
    unless @user.update(user_params)
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # DELETE /users/{username}
  def destroy
    @user.destroy
  end

  private

  def find_user
    @user = User.find_by_username!(params[:_username])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'User not found' }, status: :not_found
  end

   def create_user_api_token
    user = User.find_by_email(params[:email])
    puts"====user====="+user.inspect
    user_token = User.generate_jwt_token(user[:id])
    puts"====user_token====="+user_token.inspect
    user.update_attribute(:user_token,user_token)
  end

  def user_params
    params.permit(
      :avatar, :name, :username, :email, :password, :password_confirmation
    )
  end
end