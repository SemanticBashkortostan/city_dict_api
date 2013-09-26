class MainController < ApplicationController
  def index
  end


  def types
    @types = Metadata.pluck(:type_name).uniq
    respond_to do |format|
      format.xml  { render xml: @types}
      format.json { render json: @types}
    end
  end


  def word
    @word = VocabularyEntry.where(:name => [params[:name], params[:name].mb_chars.capitalize.to_s]).first
    respond_to do |format|
      format.json
      format.xml
    end
  end


  def all_data
    @words = VocabularyEntry.all
    respond_to do |format|
      format.json
      format.xml
    end
  end
end
