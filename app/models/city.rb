class City < ActiveRecord::Base
  attr_accessible :eng_name, :name

  has_many :metadata, :class_name => "Metadata"
end
