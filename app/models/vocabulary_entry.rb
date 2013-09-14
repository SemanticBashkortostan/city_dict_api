class VocabularyEntry < ActiveRecord::Base
  attr_accessible :city_id, :metadata, :name, :url, :source

  serialize :metadata, ActiveRecord::Coders::Hstore

  belongs_to :city
end
