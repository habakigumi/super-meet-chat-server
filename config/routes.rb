Rails.application.routes.draw do
  resources :rooms, only: %i[index show create], param: :key do
    resources :messages, only: :create
  end

  mount ActionCable.server => '/cable'
end
