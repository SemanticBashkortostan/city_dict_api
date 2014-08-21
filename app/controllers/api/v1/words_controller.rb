class Api::V1::WordsController < Api::V1::BaseController

  def index
    params[:page] ||= 1
    params[:per_page] ||= VocabularyEntry::PAGINATES_COUNT

    scope = VocabularyEntry
    if params[:city_id].present?
      scope = scope.with_city_id(params[:city_id])
    end

    if params[:type].present?
      scope = scope.with_type_name(params[:type])
    end

    if params[:source].present?
      scope = scope.with_source(params[:source])
    end

    if params[:name].present?
      scope = scope.where(name: [params[:name], params[:name].mb_chars.capitalize.to_s])
    end

    @words = scope.page(params[:page])
    @pages_data = { pages_count: @words.total_pages, per_page: params[:per_page],
                    current_page: params[:page] }
  end

  def all
    @words = VocabularyEntry.all
  end

  def fuzzy_match
    @found = VocabularyEntry.fuzzy_match(params[:words], params[:dice].to_f,
      params[:levenshtein].to_f, params[:city_id])

    # It needs here becuase this condition does not work in strange RABL!
    if @found.blank?
      render json: {} and return
    end
  end

  def show
    @word = VocabularyEntry.find(params[:id])
    @metadata = @word.metadata.where(city_id: params[:city_id]) if params[:city_id]
    @metadata ||= @word.metadata
  end
end
