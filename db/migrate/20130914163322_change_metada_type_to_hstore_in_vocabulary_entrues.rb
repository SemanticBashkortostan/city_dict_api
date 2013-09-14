class ChangeMetadaTypeToHstoreInVocabularyEntrues < ActiveRecord::Migration
  def up
    remove_column :vocabulary_entries, :metadata
    add_column :vocabulary_entries, :metadata, :hstore

    add_column :vocabulary_entries, :source, :string
  end

  def down
    remove_column :vocabulary_entries, :metadata
    add_column :vocabulary_entries, :metadata, :text

    remove_column :vocabulary_entries, :source
  end
end
