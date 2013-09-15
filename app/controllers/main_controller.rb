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
end
