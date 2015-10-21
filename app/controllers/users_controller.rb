class UsersController < ApplicationController

  # before_action :require_sign_in
  before_action :if_logged_in

  def if_logged_in
    redirect_to cats_url if logged_in?
  end

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    # @user.password = params[:password]
    @user.reset_session_token!
    if @user.save
      login!(@user)
      ########## THIS IS REDIRECTED TO CATS!!!!!#######
      redirect_to  cats_url
    else
      render :new,
      status: :unprocessable_entity
    end


  end


  private
    def user_params
      params
        .require(:user)
        .permit(:user_name, :password)
    end

end
