class CreateMetadata < ActiveRecord::Migration
  def up
    create_table :metadata do |t|
      t.integer :vocabulary_entry_id
      t.integer :city_id
      t.string :type_name
      t.string :source
      t.string :url      
      t.hstore :other      

      t.timestamps
    end

    add_index :metadata, :city_id
    add_index :metadata, :vocabulary_entry_id
    add_index :metadata, :type_name  

    add_column :vocabulary_entries, :normalized_name, :string
    add_index :vocabulary_entries, :normalized_name
    #remove_column :vocabulary_entries, :metadata
    #remove_columns :vocabulary_entries, :metadata, :source, :type, :city_id, :url    
  end

  def down
  	drop_table :metadata    
    add_column :vocabulary_entries, :metadata, :hstore
  end
end
