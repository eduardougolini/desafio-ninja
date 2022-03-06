# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :rooms, except: %i[new edit] do
        resources :appointments, except: %i[new edit], on: :member
      end
    end
  end
end
