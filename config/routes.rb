Rails.application.routes.draw do

  get 'welcome/index'
  get 'welcome/results'

  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
 
  resources :cities
  resources :departaments
  resources :owners
  resources :estates do
    collection do
      get :new_room
    end
  end

  get 'rooms/:id', to: 'estates#room', :as => 'room_estate'
  match 'estates/:id/suscribe', :to => 'estates#suscribe', :as => 'suscribe_estate', :via => :post
  match 'estates/:id/unsuscribe', :to => 'estates#unsuscribe', :as => 'unsuscribe_estate', :via => :post
  get 'estates/:id/show_detail', :to => 'estates#show_detail', :as => 'show_detail_estate'
  resources :users, only: [:index]
  resources :rooms
  resources :facilities
  resources :bookings

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # defaults to dashboard
  root :to => redirect('/welcome/index')

  # api routes
  get '/api/i18n/:locale' => 'api#i18n'

end