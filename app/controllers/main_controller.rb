class MainController < ApplicationController
  def index
  end


  def types
    @types = VocabularyEntry.all.collect{ |e| e['metadata']['type'] }.uniq
    respond_to do |format|
      format.xml  { render xml: @types}
      format.json { render json: @types}
    end
  end


  def word
    @found = VocabularyEntry.where(:name => [params[:name], params[:name].mb_chars.capitalize.to_s]).first
    respond_to do |format|
      format.json{ render json: @found }
      format.xml{ render xml: @found }
    end
  end


  def all_data
    @ves = VocabularyEntry.all
    respond_to do |format|
      format.json{ render json: @ves }
      format.xml{ render xml: @ves }
    end
  end
end
