require 'test_helper'

class VocabularyEntryTest < ActiveSupport::TestCase
  test '#fuzzy_match should find word' do
    words = ['threq']
    similarity_data = VocabularyEntry.fuzzy_match(words, 0.5, 0.5)
    assert_equal(similarity_data[:word], 'threq')
  end

  test '#fuzzy_match should not find word' do
    words = ['threq']
    similarity_data = VocabularyEntry.fuzzy_match(words, 1.0, 1.0)
    assert_equal(similarity_data, nil)
  end
end
