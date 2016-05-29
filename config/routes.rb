Rails.application.routes.draw do
  get 'user/:user_id/feed' => 'feed#index'
  get 'user/:user_id/feed/:page' => 'feed#items'
end
