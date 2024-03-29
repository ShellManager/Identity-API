# frozen_string_literal: true

require 'api_constraints'
Rails.application.routes.draw do
  root 'errors#not_found'
  get '/400' => 'errors#bad_request'
  get '/404' => 'errors#not_found'
  get '/500' => 'errors#internal_server_error'

  scope '/api', defaults: { format: :json } do
    namespace :v1 do
      resources :users, except: %i[new edit], id: /.*/
      # GET /users     # index
      # GET /users/:id # show
      # POST /users    # create
      # PUT /users/:id # update
      # DESTROY /users # destroy
      resources :sessions, only: %i[create]
      resources :details, only: %i[show], id: /.*/
      resources :identity, only: %i[index]
      resources :applications, only: %i[show], id: /.*/
      resources :keys, only: %i[index destroy]
      resources :logs, only: %i[index]
      resources :saml, only: %i[index show]
      resources :admin, path: 'admin/:operation', only: %i[show], id: /.*/
      resources :admin, only: %i[index]
      scope 'oauth' do
        get '/authorize' => 'oauth#authorize'
      end
      get "/verify/:email/:code" => "misc#verify_email", email: /.*/
      get "/reset/:email" => "misc#reset", email: /.*/
      post "/account_reset" => "misc#password"
      post "/multifactor" => "misc#multifactor"
    end
  end
end
