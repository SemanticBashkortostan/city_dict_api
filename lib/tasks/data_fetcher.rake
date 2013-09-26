# Fetching data from different sources and fill database

namespace :data_fetcher do
	namespace :dbpedia do 
		task :run do
			DbpediaFetcher.new.fill_db!
		end 
	end


	namespace :tomita do 
		task :from_xml_run do 
			TomitaFactsFetcher.new("facts.1.xml").fill_db!
		end
	end


	namespace :osm do 
		task :from_xml_run do
			OsmFetcher.fill_db!
		end

		task :generate_xmls_run do 
			#TODO: Написать скрипт который будет получать bashkortostan.osm отсюда http://gis-lab.info/projects/osm_dump/
			# формировать .osm файлы для городов. Все это будет делать в shared папке и потом делать линк 
			# в папку с проектом ln -nfs
			OsmFetcher.make_maps_from_text_classes		
		end
	end	
end