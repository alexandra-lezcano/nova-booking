Rails.application.routes.draw do

  get 'welcome/index'

  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  resources :estates do
    collection do
      get :new_room
    end
  end
  resources :cities
  resources :departaments
  resources :owners
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # defaults to dashboard
  root :to => redirect('/welcome/index')

  # api routes
  get '/api/i18n/:locale' => 'api#i18n'

end
