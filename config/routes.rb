Grammable::Application.routes.draw do
  devise_for :users
  root "grams#index"
  resources :grams do
    resources :comments, only: :create
  end  
  #resources :grams -> this will indicate that we have all crud actions connected to a
  # controller, we cuold just use this one for DRY code
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

end
