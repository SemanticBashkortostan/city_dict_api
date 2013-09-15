class TomitaFactsExtractor

  def initialize filename
    @file = "#{Rails.root}/project_files/tomita/#{filename}"
  end


  def get_facts
    facts_hash = {}
    xml = Nokogiri::XML(open(@file))
    xml.xpath('/fdo_objects/document/facts/Fact').each do |entry|
      lead_id = entry["LeadID"]
      type = entry.children[1].first.last
      value = entry.children[3].first.last

      facts_hash[lead_id] ||= Hash.new {|h, k| h[k] = Set.new }
      facts_hash[lead_id][type] << value
    end

    facts_hash = facts_hash.select{|k, v| v.keys != ["FEED"]}

    hash = {}
    facts_hash.each do |k,v|
      new_root = v["FEED"].first
      v.delete("FEED")
      hash[new_root] = v
    end

    return hash
  end

  def self.lazy filename = "facts.xml"
    tomita = TomitaFactsExtractor.new filename
    puts tomita.get_facts
  end
end