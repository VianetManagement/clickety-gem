Rails.application.routes.draw do
  post '/clickety/events', to: 'clickety_api#goal', as: 'clickety_goal'
end
