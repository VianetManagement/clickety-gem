Rails.application.routes.draw do
  post '/api/clickety/:goal', to: 'clickety_api#goal', as: 'clickety_goal'
end
