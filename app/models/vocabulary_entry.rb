class VocabularyEntry < ActiveRecord::Base
  attr_accessible :name

  PAGINATES_COUNT = 30
  paginates_per PAGINATES_COUNT

  has_many :metadata, :class_name => "Metadata"
  
  validate :normalized_name_uniqueness


  before_save :set_normalized_name


  private 


  def normalized_name_uniqueness
    if VocabularyEntry.find_by_normalized_name( get_normalized_name ) 
      p VocabularyEntry.find_by_normalized_name( get_normalized_name )
      errors.add(:normalized_name, "Uniqueness normalized_name constraint") 
    end
  end


  def set_normalized_name
    self.normalized_name ||= get_normalized_name 
  end


  def get_normalized_name
    name.mb_chars.squish.downcase
  end

end
