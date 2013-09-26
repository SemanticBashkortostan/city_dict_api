class VocabularyEntry < ActiveRecord::Base
  attr_accessible :name

  PAGINATES_COUNT = 30
  paginates_per PAGINATES_COUNT

  has_many :metadata, :class_name => "Metadata", :dependent => :destroy
  
  validate :normalized_name_uniqueness
  validates :name, :presence => true


  before_save :set_normalized_name


  # Find by name or try to normalize name and find by normalized name
  def self.find_or_create_by_name_or_normalized_name name 
    found = find_by_name(name) || find_by_normalized_name( get_normalized_name(name) )
    if found
      return found 
    else
      create! :name => name
    end
  end


  def self.get_normalized_name( name )    
    name.mb_chars.squish.downcase
  end


  private 


  def normalized_name_uniqueness
    norm_name = VocabularyEntry.get_normalized_name( self.name )
    if VocabularyEntry.find_by_normalized_name( norm_name ) 
      p VocabularyEntry.find_by_normalized_name( norm_name )
      errors.add(:normalized_name, "Uniqueness normalized_name constraint") 
    end
  end


  def set_normalized_name
    self.normalized_name ||= VocabularyEntry.get_normalized_name( self.name )
  end


end
