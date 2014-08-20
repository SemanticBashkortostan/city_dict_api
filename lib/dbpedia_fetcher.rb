# http://dbpedia.org/resource/Igor_Kravchuk
# rdf:type где url начинается со scheme
# owl:sameAs rdf:resource если с ru.dbpedia.org Извлекаем последние /  и заменяем _
# url
# ru url
# Ufa -> Description rdf:about
## dbpedia-owl:birthPlace
## dbpedia-owl:deathPlace
## dbpedia-owl:location
## dbpedia-owl:residence
## dbpedia-owl:distributor
## dbpedia-owl:producer
## dbpedia-owl:hometown

# doc.xpath('/rdf:RDF/rdf:Description/rdf:type').first.attributes["resource"].value
# doc.xpath('/rdf:RDF/rdf:Description/owl:sameAs')

# PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
# PREFIX dbpprop: <http://dbpedia.org/property/>
# PREFIX dbres: <http://dbpedia.org/resource/>

# SELECT ?resource WHERE {
# { ?resource dbpedia-owl:location dbres:Ufa }
# UNION
# { ?resource dbpedia-owl:birthPlace dbres:Ufa }
# UNION
# { ?resource dbpedia-owl:deathPlace dbres:Ufa }
# UNION
# { ?resource dbpedia-owl:residence dbres:Ufa }
# UNION
# { ?resource dbpedia-owl:distributor dbres:Ufa }
# UNION
# { ?resource dbpedia-owl:producer dbres:Ufa }
# UNION
# { ?resource dbpedia-owl:hometown dbres:Ufa }
# }

require 'sparql/client'

class DbpediaFetcher
  def initialize()
    @xpaths = {
      type: "/rdf:RDF/rdf:Description/rdf:type",
      url: "/rdf:RDF/rdf:Description/owl:sameAs",
      desciption: "/rdf:RDF/rdf:Description/dbpedia-owl:abstract[@xml:lang='ru']",
      wiki_id: "/rdf:RDF/rdf:Description/dbpedia-owl:wikiPageID"
    }
  end


  def sparql_query(city_eng_name)
    "PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
    PREFIX dbpprop: <http://dbpedia.org/property/>
    PREFIX dbres: <http://dbpedia.org/resource/>

    SELECT ?resource WHERE {
     { ?resource dbpedia-owl:location dbres:#{city_eng_name} }
     UNION
     { ?resource dbpedia-owl:birthPlace dbres:#{city_eng_name} }
     UNION
     { ?resource dbpedia-owl:deathPlace dbres:#{city_eng_name} }
     UNION
     { ?resource dbpedia-owl:residence dbres:#{city_eng_name} }
     UNION
     { ?resource dbpedia-owl:distributor dbres:#{city_eng_name} }
     UNION
     { ?resource dbpedia-owl:producer dbres:#{city_eng_name} }
     UNION
     { ?resource dbpedia-owl:hometown dbres:#{city_eng_name} }
    }"
  end

  def fill_db!
    sparql = SPARQL::Client.new("http://dbpedia.org/sparql")

    City.all.each do |city|
      result = sparql.query(sparql_query(city.eng_name), content_type: SPARQL::Client::RESULT_JSON)
      result.each do |rdf|
        xml_url = rdf.resource.to_s
        xml_url["resource"] = "data"
        create_or_update_metadata(xml_url, city)
      end
    end
  end

  def create_or_update_metadata(xml_url, city)
    resource_xml = Nokogiri::XML(open(xml_url))

    type = get_specific_attr(resource_xml, :type, "schema.org")
    ru_url = get_specific_attr(resource_xml, :url, "ru.dbpedia")
    description = resource_xml.xpath(@xpaths[:desciption]).first.text

    if ru_url
      rus_name = get_rus_name(ru_url)
      token = VocabularyEntry.find_or_create_by_name_or_normalized_name(rus_name)

      params ={ source: :dbpedia, city_id: city.id, url: xml_url,
        type_name: type, vocabulary_entry_id: token.id }
      metadata = Metadata.where(params).first || Metadata.create(params)

      if metadata.other["ru_url"].nil?
        metadata.other["ru_url"] = ru_url
      end

      wiki_id = resource_xml.xpath(@xpaths[:wiki_id]).first.text
      wiki_xml = Nokogiri::XML(open(wiki_url(wiki_id)))
      rus_wiki_url = wiki_xml.xpath("*//ll[@lang='ru']").first.attributes["url"].value

      if rus_wiki_url && metadata.other["rus_wiki_url"].nil?
        metadata.other["rus_wiki_url"] = rus_wiki_url
        metadata.other["wiki_id"] = wiki_id
      end

      metadata.save!
    end
    metadata
  end


  private


  def get_rus_name(ru_url)
    ru_url.split("/").last.tr("_", " ")
  end

  def get_specific_attr(xml, xpath_key, filter)
    xml.xpath(@xpaths[xpath_key]).each do |entry|
      if entry.attributes["resource"].value[filter]
        return entry.attributes["resource"].value
      end
    end
    nil
  end

  def wiki_url(wiki_id)
    "https://en.wikipedia.org/w/api.php?action=query&pageids=#{wiki_id}&prop=langlinks&llurl=true&lllimit=50&format=xml"
  end
end
