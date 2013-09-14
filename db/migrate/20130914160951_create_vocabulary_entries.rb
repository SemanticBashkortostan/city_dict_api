class CreateVocabularyEntries < ActiveRecord::Migration
  def change
    create_table :vocabulary_entries do |t|
      t.integer :city_id
      t.string :name
      t.text :metadata

      t.timestamps
    end

    add_index :vocabulary_entries, :city_id
    add_index :vocabulary_entries, :name
    add_index :vocabulary_entries, [:city_id, :name]
  end
end
