class VocabularyEntry < ActiveRecord::Base
  attr_accessible :name

  PAGINATES_COUNT = 30
  paginates_per PAGINATES_COUNT

  validate :city_name_and_type_uniqueness


  private


  def city_name_and_type_uniqueness
    maybe_similars = VocabularyEntry.where(:city_id => city_id, :name => name)
    if maybe_similars.collect{ |ve| ve.metadata['type'] }.include?(self.type) 
      errors.add(:base, "City_id and name and type is not uniqueness") 
    end
  end
end
