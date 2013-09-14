class ChangeMetadaTypeToHstoreInVocabularyEntrues < ActiveRecord::Migration
  def up
    remove_column :vocabulary_entries, :metadata
    add_column :vocabulary_entries, :metadata, :hstore
  end

  def down
    remove_column :vocabulary_entries, :metadata
    add_column :vocabulary_entries, :metadata, :text
  end
end
