Rails.application.routes.draw do

  get 'comments/save'
  # defaults to dashboard
  root :to => redirect('/welcome/index')

  get 'welcome/index'
  get 'welcome/results'
  get 'welcome/resources'

  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  devise_scope :user do
    get '/users', to: 'devise/registrations#new'
    get '/users/password', to: 'devise/passwords#new'
  end

  resources :cities
  resources :departaments
  resources :owners
  resources :offers
  resources :estates do
    collection do
      get 'estates_visited', :to => 'estates#estates_visited', :as => 'visited'
      get :new_room
      post :unsuscribe_estate
    end
  end

  delete 'estates/:id/remove_image', to: 'estates#remove_image', :as => 'remove_image_estate'
  get 'rooms/:id', to: 'estates#room', :as => 'room_estate'
  get 'estates/:id/show_detail', :to => 'estates#show_detail', :as => 'show_detail_estate'
  get 'estates/:id/show_visited', :to => 'estates#show_visited', :as => 'show_visited_estate'

  resources :users, only: [:index]
  resources :rooms
  resources :facilities, except: :show
  resources :bookings, except: [:edit, :update ,:index, :delete] do
    collection do
      get :confirmation
    end
  end
  resources :comments, only: [] do
    collection do
      post :save
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # api routes
  get '/api/i18n/:locale' => 'api#i18n'

  # error routes
  get '404', to: 'errors#page_not_found'
  get '422', to: 'errors#server_error'
  get '500', to: 'errors#server_error'

end