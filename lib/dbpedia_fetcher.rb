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

#PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
#PREFIX dbpprop: <http://dbpedia.org/property/>
#PREFIX dbres: <http://dbpedia.org/resource/>
#
#SELECT ?resource WHERE {
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
#}

require 'sparql/client'

class DbpediaFetcher
  def initialize
    @xpaths = { type: "/rdf:RDF/rdf:Description/rdf:type",
                url: "/rdf:RDF/rdf:Description/owl:sameAs" }

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
      result = sparql.query( sparql_query(city.eng_name) )
      result.each do |rdf|
        url = rdf.resource.to_s
        url["resource"] = "data"

        resource_xml = Nokogiri::XML(open(url))

        type = nil
        resource_xml.xpath(@xpaths[:type]).each do |entry|
          if entry.attributes["resource"].value["schema.org"]
            type = entry.attributes["resource"].value
            break
          end
        end

        ru_url = nil
        resource_xml.xpath(@xpaths[:url]).each do |entry|
          if entry.attributes["resource"].value["ru.dbpedia"]
            ru_url = entry.attributes["resource"].value
            break
          end
        end

        if ru_url
          rus_name = get_rus_name(ru_url)         
          begin 
          
          ve = VocabularyEntry.create! name: rus_name

          metadata = Metadata.new source: :dbpedia, city_id: city.id, vocabulary_entry_id: ve.id
          metadata.type_name = type if type 
          metadata.other["ru_url"] = ru_url if ru_url
          metadata.url = url          
          metadata.save! 
          
          rescue Exception => e 
            puts "Exception in DbpediaFetcher#fill_db!: #{e}"
          end
        end

      end
    end
  end


  private


  def get_rus_name ru_url
    ru_url.split("/").last.tr! "_", " "
  end


end