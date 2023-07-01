# frozen_string_literal: true

Rails.application.routes.draw do
  resources :projects do
    resources :bugs, shallow: true do
      member do
        post 'assign_bug'
        post 'bug_resolved'
      end
    end
    member do
      get 'assign_user_to_project'
      delete :remove_from_project
      get :add_user_modal
      post :add_user
    end
  end
  post '/update_dropdown', to: 'bugs#update_dropdown'
  devise_scope :user do
    root to: 'devise/sessions#new'
  end
  devise_for :users, controllers: { users: 'users' }

  namespace :api do
    namespace :v1 do
      resources :projects, only: %i[index show] do
        resources :bugs, shallow: true, only: %i[index show]
      end
    end
  end
end
