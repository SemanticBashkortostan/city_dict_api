class VocabularyEntry < ActiveRecord::Base
  attr_accessible :name

  PAGINATES_COUNT = 30
  paginates_per PAGINATES_COUNT

  has_many :metadata, :class_name => "Metadata", :dependent => :destroy

  validate :normalized_name_uniqueness
  validates :name, :presence => true

  before_save :set_normalized_name

  scope :with_city_id, lambda{ |city_id| includes(:metadata)
    .where(metadata: {city_id: city_id}) }


  # Find by name or try to normalize name and find by normalized name
  def self.find_or_create_by_name_or_normalized_name(name)
    found = find_by_name(name) || find_by_normalized_name(get_normalized_name(name))
    if found
      return found
    else
      create! :name => name
    end
  end

  def self.get_normalized_name(name)
    name.mb_chars.squish.downcase.delete('.,').to_s
  end

  # This function do fuzzy string match between +words+ and VocabularyEntry.all
  def self.fuzzy_match(words, dice_threshold, levenshtein_threshold, city_id=nil)
    scope = self
    scope = scope.with_city_id(city_id) if city_id.present?
    norm_words = words.map{|word| VocabularyEntry.get_normalized_name(word)}

    FuzzyMatch.engine = :amatch
    fz = FuzzyMatch.new(scope.all, read: :normalized_name)

    most_similar = {levenshtein: 0, dice: 0}
    norm_words.each_with_index do |word, ind|
      found = fz.find_all_with_score(word).sort_by{|e| e[2]}.reverse.first
      if found && found[1] >= dice_threshold && found[2] >= levenshtein_threshold
        if most_similar[:levenshtein] < found[2] && most_similar[:dice] < found[1]
          most_similar[:levenshtein] = found[2]
          most_similar[:dice] = found[1]
          most_similar[:word] = words[ind]
          most_similar[:found] = found[0]
        end
      end
    end
    (most_similar[:found]) ? (return most_similar) : (return nil)
  end


  private


  def normalized_name_uniqueness
    norm_name = VocabularyEntry.get_normalized_name(self.name)
    if VocabularyEntry.find_by_normalized_name(norm_name)
      errors.add(:normalized_name, "Uniqueness normalized_name constraint")
    end
  end

  def set_normalized_name
    self.normalized_name ||= VocabularyEntry.get_normalized_name(self.name)
  end

end
