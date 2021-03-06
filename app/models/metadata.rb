class Metadata < ActiveRecord::Base
  attr_accessible :other, :source, :type_name, :url, :city_id, :vocabulary_entry_id

  serialize :other, ActiveRecord::Coders::Hstore

  belongs_to :vocabulary_entry
  belongs_to :city
end
