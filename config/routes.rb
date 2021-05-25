Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'user/register' , to: 'users#register'
  post 'authenticate', to: 'authentication#authenticate'
  
  resources :endpoints , only: [:index, :create, :update, :destroy]

  #match "sample/register/*path", to: redirect('/404'), via: :all
  #match "user/(*url)", to: redirect('/404'), via: :all

  match "*path", to: "echo#echo_action", via: :all
end
