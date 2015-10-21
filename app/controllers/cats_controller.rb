class CatsController < ApplicationController

  before_action :require_logged_in

  def require_logged_in
    redirect_to new_session_url unless logged_in?

  end

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def create
    @cat = Cat.new(cat_params)
    if @cat.save
      redirect_to cats_url
    else
      render :new,
      status: :unprocessable_entity
    end
  end

  def new
    @cat = Cat.new
    render :new
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update_attributes(cat_params)
      redirect_to cat_url
    else
      render :new,
      status: :unprocessable_entity
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def destroy

  end

  private

  def cat_params
    params
      .require(:cat)
      .permit(:name, :birth_date, :sex, :color, :description)
  end
end
