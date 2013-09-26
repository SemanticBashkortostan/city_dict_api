class WordsController < ApplicationController

  def index    
    words = VocabularyEntry.includes(:metadata).where( :metadata => { :city_id => params[:city_id] } )
    words = words.where(:type_name => params[:type]) if params[:type].present?    
    @words = words.page(params[:page])
    @pages_data = {:pages_count => @words.total_pages, :per_page => VocabularyEntry::PAGINATES_COUNT}

    respond_to do |format|
      format.xml
      format.json
    end
  end


  def show
    @word = VocabularyEntry.find(params[:id])
    
    respond_to do |format|
      format.xml 
      format.json
    end
  end
end
