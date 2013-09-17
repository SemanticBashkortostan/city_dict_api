class WordsController < ApplicationController

  def index
    words = City.find( params[:city_id] ).vocabulary_entries
    words = words.where("metadata -> 'type' = :value", value: params[:type]) if params[:type]
    @words = words.page(params[:page])
    @pages_data = {:pages_count => @words.total_pages, :per_page => VocabularyEntry::PAGINATES_COUNT}

    respond_to do |format|
      format.xml
      format.json
    end
  end


  def show
    word = VocabularyEntry.find_by_id_and_city_id(params[:id], params[:city_id])

    respond_to do |format|
      format.xml  { render xml: word}
      format.json { render json: word}
    end
  end
end
