class WordsController < ApplicationController

  def index
    words = City.find( params[:city_id] ).vocabulary_entries

    respond_to do |format|
      format.xml  { render xml: words}
      format.json { render json: words}
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
