class TomitaFactsExtractor

  def initialize filename
    @file = "#{Rails.root}/project_files/tomita/#{filename}"
  end


  def get_facts
    facts_hash = {}
    xml = Nokogiri::XML(open(@file))
    xml.xpath('/fdo_objects/document/facts/Fact').each do |entry|
      lead_id = entry["LeadID"]
      type = entry.children[0].first.last
      value = entry.children[1].first.last

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

    last_hash = {}
    hash.each do |k,v|
      new_root = v["CITY"].first
      v.delete("CITY")
      if v.present? && new_root.present?
        last_hash[new_root] ||= Set.new
        last_hash[new_root] <<  v
      end
    end

    return last_hash
  end


  def self.lazy filename = "facts-1.xml"
    tomita = TomitaFactsExtractor.new filename
    tomita.get_facts.each do |city_name, set_of_hash|
      set_of_hash.each do |hash|
        hash.each do |type, values|
          values.each do |named_entity|
            ve = VocabularyEntry.new name: named_entity, city_id: find_city(city_name), source: :tomita
            ve.url = "http:://rbcitynews.ru"
            ve.metadata["type"] = type
            ve.save
          end
        end
      end
    end
  end


  def prepare_data_for_tomita
    file = File.open("#{Rails.root}/project_files/tomita/for_tomita.txt", 'w')
    for i in 1...470 do
      fetch_remote_json( generate_url_for_rbcitynews( i ) ).each do |feed|
        if feed["summary"]
    	    file.puts CGI::unescapeHTML(feed["summary"]).gsub('.', " (feed#{feed["id"]}).")
        end
      end
    end
    file.close
  end


  def generate_url_for_rbcitynews page_num
    "http://rbcitynews.ru/all.json?page=#{page_num}"
  end


  def fetch_remote_json(url)
    resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body
    JSON.parse(data)
  end


  def self.find_city city_name
    City.find_by_name(city_name.mb_chars.capitalize.to_s).try :id
  end

end