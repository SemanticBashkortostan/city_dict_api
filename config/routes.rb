CityDictApi::Application.routes.draw do
  root :to => "main#index"
  match '/documentation' => "main#documentation"
  match '/presentation' => "main#presentation"

  namespace :api do
    namespace :v1 do
      resources :cities do
        resources :words do
          get :fuzzy_match, on: :collection
        end
      end
      resources :words, only: [:show, :index] do
        get :all, on: :collection
      end

      get '/types' => "main#types"
      get '/sources' => "main#sources"
    end
  end
end
