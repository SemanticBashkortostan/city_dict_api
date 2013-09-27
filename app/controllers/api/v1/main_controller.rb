class Api::V1::MainController < Api::V1::BaseController
  def index
  end


  def types
    @types = Metadata.pluck(:type_name).uniq
    respond_to do |format|
    	format.xml{ render :xml => @types }
    	format.json{ render :json => @types }
    end
  end
  
end
