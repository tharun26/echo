Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'user/register' , to: 'users#register'
  post 'authenticate', to: 'authentication#authenticate'
  
  resources :endpoints , only: [:index, :create, :update, :destroy]

  match "*path", to: "echo#echo_action", via: :all
  #match 'unmatch_route/not_found', to: 'unmatch_route#not_found', via: :all

end
