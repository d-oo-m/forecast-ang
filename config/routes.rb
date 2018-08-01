Rails.application.routes.draw do
  get 'weather/index'

  get 'users', to: 'weather#list_users'

  get 'city', to: 'weather#city'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
