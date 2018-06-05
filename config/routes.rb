Rails.application.routes.draw do
  resources :customers
  devise_for :users
  root to: 'static_pages#index'
  resources :company_informations, only: [:edit, :create, :update]
  get '/mysetting', to: 'company_informations#edit'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
end
