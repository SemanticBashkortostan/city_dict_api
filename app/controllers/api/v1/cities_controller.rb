class Api::V1::CitiesController < Api::V1::BaseController 

  def show 
    @city = City.find params[:id]   
  end


  def index
    @cities = City.all    
  end

end
