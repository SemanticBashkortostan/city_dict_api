class Metadata < ActiveRecord::Base
  attr_accessible :other, :source, :type_name, :url

  belongs_to :vocabulary_entry
  belongs_to :city
end
