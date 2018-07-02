Rails.application.routes.draw do
  resources :closing_groups
  resources :earnings
  resources :delivery_slips
  resources :orders
  resources :order_details, only: [:show]
  resources :estimates
  resources :sales_reports
  resources :prospects
  resources :products
  resources :customers do
    collection do
      get :import_form
      post :import
    end
  end
  resources :company_informations, only: [:edit, :create, :update]
  devise_for :users
  root to: 'static_pages#index'
  get '/mysetting', to: 'company_informations#edit'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
end
