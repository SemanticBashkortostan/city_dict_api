node(:per_page) {|m| @pages_data[:per_page] }
node(:pages_count) {|m| @pages_data[:pages_count]}

child :@words do
    attributes :id, :city_id, :name, :url, :source, :metadata
end