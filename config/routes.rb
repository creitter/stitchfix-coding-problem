Rails.application.routes.draw do
  resources :clearance_batches, only: [:index, :create]
  root to: "clearance_batches#index"
  resources :items, only:[:index]
  
  get 'show_all_items' => 'clearance_batches#show_all_items'
end
