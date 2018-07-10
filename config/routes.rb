Rails.application.routes.draw do
  resources :closing_groups
  resources :earnings
  resources :delivery_slips
  resources :orders
  resources :order_details, only: [:show]
  resources :estimates do
    member do
      get :report
    end
  end
  resources :sales_reports
  resources :prospects
  resources :products
  resources :customers do
    collection do
      get :import_form
      post :import
    end
  end
  resources :company_informations, only: [:edit, :update]
  resources :user_profiles
  devise_for :users, skip: :registrations
  devise_scope :user do
    resource :user_registration,
      only: [:new, :create],
      path: 'users',
      path_names: { new: 'sign_up' },
      controller: 'registrations'
  end

  root to: 'static_pages#index'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
end
