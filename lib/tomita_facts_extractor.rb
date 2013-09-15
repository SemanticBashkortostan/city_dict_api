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

    last_hash = {}
    hash.each do |k,v|
      new_root = v["CITY"].first
      v.delete("CITY")
      if v.present? && new_root
        last_hash[new_root] ||= Set.new
        last_hash[new_root] <<  v
      end
    end

    return last_hash
  end


  def self.lazy filename = "facts.xml"
    tomita = TomitaFactsExtractor.new filename
    puts tomita.get_facts
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

end