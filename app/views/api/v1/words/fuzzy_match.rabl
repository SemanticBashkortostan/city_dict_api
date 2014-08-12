node do |u|
  {
    levenshtein: @found[:levenshtein],
    dice: @found[:dice],
    original_word: @found[:word],
    found: partial("api/v1/words/_word", object: @found[:found])
  }
end
