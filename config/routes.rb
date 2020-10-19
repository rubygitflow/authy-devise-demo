Rails.application.routes.draw do
  devise_for :users
  get "guide", to: "welcome#guide"
  root :to => "welcome#index"
end
