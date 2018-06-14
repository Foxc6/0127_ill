require 'api_constraints'
Rails.application.routes.draw do
  resources :estimates

  resources :projects

  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root 'welcome#index'

  get '/preferences' => 'preferences#show', :as => 'preference'
  get '/preferences/setup' => 'preferences#index'
  get '/preferences/:id/edit' => 'preferences#edit', :as => 'edit_preference'
  post '/preference/:id' => 'preferences#update'
  get '/preferences/new' => 'preferences#new'
  post '/preferences' => 'preferences#create'
  get '/search' => 'search#show', :as => 'search'
  get 'welcome/data' => "welcome#data", as: 'data'
  post 'welcome/data/task' => 'projects#new'
  post 'welcome/data/task/:id' => 'projects#update'
  post 'welcome/data/link' => 'links#add'
  post 'welcome/data/link/:id' => 'links#update'
  delete 'welcome/data/link/:id' => 'links#delete'
  get '/help' => 'welcome#help', as: 'help'

  get '/account' => 'account#show'
  get '/account/edit' => 'account#edit'
  get '/account/activity' => 'account#activities'
  get '/account/tasks' => 'account#tasks'

  #Social Networks
  get '/settings' => 'settings#index'
  #linkedin
  get '/auth' => 'settings#auth'
  get '/auth/settings/social-networks/linkedin' => 'settings#linkedin_callback'
  get '/auth/settings/social-networks/linkedin/company' => 'settings#linkedin_callback'
  get '/settings/social-networks/linkedin' => 'settings#linkedin'
  #facebook
  get '/settings/social-networks/facebook' => 'settings#facebook'
  post '/settings/social-networks/facebook' => 'settings#facebook_auth'
  #twitter
  get '/settings/social-networks/twitter' => 'settings#twitter'
  post '/settings/social-networks/twitter' => 'settings#twitter_call'
  #pinterest
  get '/settings/social-networks/pinterest' => 'settings#pinterest'
  #instagram
  get '/settings/social-networks/instagram' => 'settings#instagram'
  get '/settings/social-networks/instagram/auth_instagram' => 'settings#auth_instagram'
  get '/settings/social-networks/instagram/insta_callback' => 'settings#insta_callback'
  #tumblr
  get '/settings/social-networks/tumblr' => 'settings#tumblr'
  #youtube
  get '/settings/social-networks/youtube' => 'settings#youtube'

  get '/contacts/:id/activity' => 'contacts#activity'
  get '/contacts/:id/tasks' => 'contacts#tasks'
  post '/contacts/create_linkedin' => 'contacts#create_linkedin'
  post '/contacts/:id/become_client' => 'contacts#become_client'
  get '/compose' => 'compose#index'

  resources :users, :archives, :contacts, :activities, :tasks, :teams
  resources :clients, param: :slug
  resources :projects, param: :project_number
  resources :options

  post '/projects/:id/remove_tag' => 'projects#remove_tag', :as => 'remove_tag'
  post '/projects/:id/add_tag' => 'projects#add_tag', :as => "add_tag"
  post '/projects/:project_number/archive' => 'projects#archive', :as => 'archive_project'
  post '/projects/:project_number/activate' => 'projects#activate_project', :as => 'activate_project'
  get 'sales/payments' => 'sales#payments'
  get 'sales/payments/data' => 'sales#payments_data', :as => 'payments'
  resources :sales, param: :case_number

  namespace :api,  defaults: { format: 'json' } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      get 'compose' => 'compose#index'
      post 'get-text-sentiment' => 'compose#getTextSentiment'
      post 'get-url-sentiment' => 'compose#getURLSentiment'
    end
  end


end
