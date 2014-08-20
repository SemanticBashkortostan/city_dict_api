require 'test_helper'

class DbpediaFetcherTest < ActiveSupport::TestCase
  test "#create_or_update_metadata" do
    df = DbpediaFetcher.new
    url = 'http://dbpedia.org/data/Lev_Matveyev'
    metadata = df.create_or_update_metadata(url, cities(:one))
    assert_equal metadata.other['wiki_id'], "22992795"
  end
end
