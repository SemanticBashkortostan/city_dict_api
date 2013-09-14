class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.string :eng_name

      t.timestamps
    end

    add_index :cities, :name

    Settings.default_cities.each{|rus_name, eng_name| City.create! name: rus_name, eng_name: eng_name}
  end
end
