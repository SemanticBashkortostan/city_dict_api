class City < ActiveRecord::Base
  attr_accessible :eng_name, :name

  has_many :vocabulary_entries
end
