class DeleteOldColumnsFromVocabularyEntry < ActiveRecord::Migration
  def up
  	remove_columns :vocabulary_entries, :metadata, :city_id, :url, :source       
  end

  def down  	
    add_column :vocabulary_entries, :metadata, :hstore
    add_column :vocabulary_entries, :source, :string
    add_column :vocabulary_entries, :url, :string
    add_column :vocabulary_entries, :city_id, :integer
  end
end
