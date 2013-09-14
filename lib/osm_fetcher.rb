require 'nokogiri'

class OsmFetcher


  ISHIMBAY_BOUNDING_BOX = {:top => 53.4731, :left => 55.9502, :bottom => 53.3999, :right => 56.1322}
  SALAVAT_BOUNDING_BOX = {:top => 53.3862, :left => 55.8489, :bottom => 53.3054, :right => 55.999}
  STERLITAMAK_BOUNDING_BOX = {:top => 53.7523, :left => 55.7659, :bottom => 53.5619, :right => 56.1744}
  NEFTEKAMSK_BOUNDING_BOX = {:top => 56.1428, :left => 54.1406, :bottom => 55.9649, :right => 54.4221}
  UFA_BOUNDING_BOX = {:top => 54.8943, :left => 55.7638, :bottom => 54.5258, :right => 56.21}


  # +bounding_box+ is a Hash, look at up
  def initialize(bounding_box, filename )
    @bounding_box = bounding_box
    @filename = "#{Rails.root}/project_files/osm_maps/#{filename}"
  end


  def get_part_of_map( main_map = "#{Rails.root}/project_files/bashkortostan.osm" )
    raise Exception unless File.exist?(main_map)
    exec = "osmosis --read-xml file=\"#{main_map}\" --bounding-box top=#{@bounding_box[:top]} left=#{@bounding_box[:left]} \
            bottom=#{@bounding_box[:bottom]} right=#{@bounding_box[:right]} --write-xml file=\"#{@filename}\""
    system exec
  end


  # Return array with elements like [name, amenity, osm_id]
  # where name.length > 2
  def get_features
    xmlfeed = Nokogiri::XML(open(@filename))
    rows = xmlfeed.xpath("//*[@k=\"name\"]")
    features = []
    rows.each do |row|
      name = row.attributes['v'].value
      osm_id = row.parent.attributes["id"].value
      amenity = row.parent.xpath("tag[@k=\"amenity\"]").first
      amenity = amenity.attributes["v"].value if amenity
      features << [name, amenity, osm_id] if name.length > 2
    end
    return features
  end


  def self.make_maps_from_text_classes
    osm_arr = [
                ["sterlitamak.osm", OsmFetcher::STERLITAMAK_BOUNDING_BOX],
                ["salavat.osm", OsmFetcher::SALAVAT_BOUNDING_BOX],
                ["neftekamsk.osm", OsmFetcher::NEFTEKAMSK_BOUNDING_BOX],
                ["ishimbay.osm", OsmFetcher::ISHIMBAY_BOUNDING_BOX],
                ["ufa.osm", OsmFetcher::UFA_BOUNDING_BOX]
              ]
    osm_arr.each do |(filename, bounding_box)|
      osm = OsmFetcher.new bounding_box, filename
      osm.get_part_of_map
    end
  end


  #TODO: Add version of .osm file!!!
  def self.fill_db!
    osm_arr = [
                      ["Sterlitamak", "sterlitamak.osm", OsmFetcher::STERLITAMAK_BOUNDING_BOX],
                      ["Salavat", "salavat.osm", OsmFetcher::SALAVAT_BOUNDING_BOX],
                      ["Neftekamsk", "neftekamsk.osm", OsmFetcher::NEFTEKAMSK_BOUNDING_BOX],
                      ["Ishimbay", "ishimbay.osm", OsmFetcher::ISHIMBAY_BOUNDING_BOX],
                      ["Ufa", "ufa.osm", OsmFetcher::UFA_BOUNDING_BOX]
               ]

    osm_arr.each do |(city_eng_name, filename, bounding_box)|
      osm = OsmFetcher.new bounding_box, filename
      osm.get_features.each do |name, amenity, osm_id|
        ve = VocabularyEntry.new name: name, city_id: City.find_by_eng_name(city_eng_name).id, source: :osm
        ve.metadata['type'] = amenity
        ve.metadata['osm_id'] = osm_id
        ve.metadata['bounding_box'] = bounding_box.to_s
        ve.save!
      end
    end
  end


end
