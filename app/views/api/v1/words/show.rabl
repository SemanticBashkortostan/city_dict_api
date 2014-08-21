object @word

child :@word do
  extends('api/v1/words/_word')
  child(:@metadata){attribute :city_id, :created_at, :id, :other, :source,
    :type_name, :updated_at, :url, :vocabulary_entry_id}
end
