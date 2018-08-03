Rails.application.routes.draw do
  get 'weather/index'

  get 'users', to: 'weather#list_users'

  get 'location', to: 'weather#location'

  root 'weather#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
