Rails.application.routes.draw do
  get 'weather/index'

  get 'users', to: 'weather#list_users'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
