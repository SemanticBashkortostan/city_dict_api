node(:per_page) {|m| @pages_data[:per_page] }
node(:pages_count) {|m| @pages_data[:pages_count]}
node(:current_page) {|m| @pages_data[:current_page]}

child :@words do
  attributes :id, :name, :normalized_name, :metadata
end