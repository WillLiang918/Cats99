class CatsController < ApplicationController

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def create
    Cat.create!(cat_params)
    redirect_to cats_url
  end

  def new
    render :new
  end

  def update
    @cat = Cat.find(params[:id])
    @cat.update_attributes(cat_params)
    redirect_to cat_url
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  private

  def cat_params
    params
      .require(:cat)
      .permit(:name, :birth_date, :sex, :color, :description)
  end
end
