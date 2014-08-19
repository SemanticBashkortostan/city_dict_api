class Api::V1::MainController < Api::V1::BaseController
  def index
  end


  def types
    @types = Metadata.pluck(:type_name).uniq
    respond_to do |format|
    	format.xml{ render xml: @types }
    	format.json{ render json: @types }
    end
  end

  def sources
    @sources = Metadata.pluck(:source).uniq
    respond_to do |format|
      format.xml{ render xml: @sources }
      format.json{ render json: @sources }
    end
  end

end
