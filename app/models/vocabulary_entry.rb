class VocabularyEntry < ActiveRecord::Base
  attr_accessible :city_id, :metadata, :name, :url, :source

  serialize :metadata, ActiveRecord::Coders::Hstore

  belongs_to :city

  validates :city_id, :presence => true
  validate :city_and_name_uniqueness


  def own_type
    #[nil, "fuel", "library", "post_office", "hospital", "bus_station", "bank",
    # "cinema", "public_building", "place_of_worship", "school", "university",
    # "parking", "marketplace", "kindergarten", "college", "http://schema.org/Person",
    # "theatre", "restaurant", "http://schema.org/StadiumOrArena", "http://schema.org/Place",
    # "http://schema.org/Organization", "http://schema.org/Airport", "http://schema.org/Movie",
    # "http://schema.org/MusicGroup", "pharmacy", "police", "car_wash", "cafe", "fast_food",
    # "doctors", "arts_centre", "dentist", "bar", "fountain", "pub", "nightclub", "atm",
    # "fire_station", "swimming_pool", "grave_yard", "bench", "driving_school", "register_office", "courthouse",
    # "recycling", "taxi", "townhall", "social_facility", "prison", "sanatorium", "bicycle_rental", "community_centre"]
  end


  private


  def city_and_name_uniqueness
    errors.add(:base, "City id and name is not uniqueness") if VocabularyEntry.find_by_city_id_and_name( city_id, name )
  end
end
