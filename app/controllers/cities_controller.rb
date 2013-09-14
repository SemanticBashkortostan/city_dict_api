class CitiesController < ApplicationController
  before_filter :find, :only => :show


  def show
    respond_to do |format|
      format.xml  { render xml: @city}
      format.json { render json: @city}
    end
  end


  def index
    @cities = City.all
    respond_to do |format|
      format.xml  { render xml: @cities}
      format.json { render json: @cities}
    end
  end


  private


  def find
    @city = City.find params[:id]
  end
end
