class SessionsController < ApplicationController

  before_action :if_logged_in, only: [:new, :create]

  def if_logged_in
    redirect_to cats_url if logged_in?
  end

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(
      params[:user][:user_name],
      params[:user][:password]
    )
    if @user.nil?
      render json: "Incorrect username/password"
    else
      # @user.reset_session_token!
      login!(@user)
      redirect_to cats_url
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end

end
