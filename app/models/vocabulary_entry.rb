class VocabularyEntry < ActiveRecord::Base
  attr_accessible :city_id, :metadata, :name, :url

  belongs_to :city
end
