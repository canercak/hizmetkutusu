 
Hizmetkutusu::Application.routes.draw do 
  
  get 'customers/index' 
  get 'customers/edit' 
  get 'customers/update' 
  get 'customers/show' 
  get 'customers/destroy' 
  get 'customers/new' 
  get 'customers/create' 
  root :to => "pages#home" 
  #dds
  mount Resque::Server, at: "/resque" if defined?(Resque::Server)

  get "translations/index"
  get 'transaction' => 'transactions#transaction'
  get '/transactions/refund_transaction' => 'transactions#refund_transaction', :via => :get
  get 'transparent_redirect_complete' => 'transactions#transparent_redirect_complete'
  get 'successful_transaction' => 'transactions#successful_transaction'
  post '/providers/getlocation'  => 'providers#getlocation', :via => :post
  get '/providers/getlocation'  => 'providers#getlocation', :via => :get
  get '/providers/check_phone'  => 'providers#check_phone', :via => :get
  get '/providers/check_email'  => 'providers#check_email', :via => :get
  get '/providers/check_pin'  => 'providers#check_pin', :via => :get
  get '/providers/disabled_days'  => 'providers#disabled_days', :via => :get
  get '/providers/available_hours'  => 'providers#available_hours', :via => :get
  get '/quotes/user_prices'  => 'quotes#user_prices', :via => :get
  get '/quotes/landing_direct'  => 'quotes#landing_direct', :via => :get
  get '/providers/verification'  => 'providers#verification', :via => :get
  get '/providers/customer_list'  => 'providers#customer_list', :via => :get
  get '/providers/personel_list'  => 'providers#personel_list', :via => :get
  get '/quotes/multiples'  => 'quotes#multiples', :via => :get
  get '/providers/check_tax_number'  => 'providers#check_tax_number', :via => :get
  get '/quotes/getaddress'  => 'quotes#getaddress', :via => :get
  get '/providers/getuserproviders' => 'providers#getuserproviders', :via => :get
  get '/providers/getprovider' => 'providers#getprovider', :via => :get
  get '/providers/getprovideraddress'  => 'providers#getprovideraddress', :via => :get
  get '/quotes/getselectedproviders'  => 'quotes#getselectedproviders', :via => :get
  get '/quotes/getproviderworkdone'  => 'quotes#getproviderworkdone', :via => :get
  post '/check_verification_code', :to => 'application#check_verification_code', :as => 'check_verification_code_quote'
  get '/sendverification', :to => 'application#sendverification', :as => 'sendverification_quote'
  get '/increment_login_count', :to => 'application#increment_login_count'
  get '/users/check_email'  => 'users#check_email', :via => :get
  get '/users/check_phone_exists'  => 'users#check_phone_exists', :via => :get
  get '/users/get_user'  => 'users#get_user', :via => :get 
  post '/users/create_dummy'  => 'users#create_dummy', :via => :post
  post 'reservations/save' => 'reservations#save', as: :save, :via => :post
  post 'quotes/create' => 'quotes#create', :via => :post
  get "local" => "addresses#find_children"
  get "district" => "addresses#find_children"
  get "neigbor" => "addresses#find_children"
 
  resources :activities do 
    collection do
      get :get_provider_counts
      get :get_activity
    end
  end
 
  resources :reservations do

    get :load_scheduler, on: :collection
    get :provider_all, on: :collection
    get :events_block, on: :collection
    get :personels_block, on: :collection
    get :events_personel, on: :collection
    get :get_blocked_times, on: :collection
    get :get_user_blocks, on: :collection
    get :get_calendar_range, on: :collection
    get :check_blocked, on: :collection
    get :get_price, on: :collection
    get :manage_blocks, on: :collection
    get :update_price, on: :collection
    get :check_block_valid, on: :collection
    get :check_event_valid, on: :collection
    get :load_event, on: :collection 
    get :provider_users, on: :collection
    get :match_personel, on: :collection
    get :personel_list, on: :collection 
    get :delete_block, on: :collection 
    post :cancel_reservation,  on: :member
  end
 
  resources :blocked_hours do
    post :save, on: :collection
  end 

  resources :categories do
    get :get_variation, on: :collection
    get :list_styles, on: :collection
    get :get_allcategories, on: :collection
  end
 
  
  
  localized do
    resources :feedbacks, only: [:show, :new, :create, :edit, :update, :destroy, :index] 
    
    resources :quotes do #, only: [:show, :new, :create, :edit, :update, :destroy, :index, :search] do
      get :providers, on: :member
      get :give, on: :member
     
 
      resources :build
    end
    
    resources :workdones do
      put :update_all, on: :member
    end  
 
    resources :providers  do
      resources :customers
      get :new, on: :collection
      get :quotes, on: :member   
      get :prices, on: :member 
      get :customers, on: :member 
      get :calendar, on: :member 
      post :search, on: :collection 
      get :provider_image, on: :member
    end
  
    resources :references
  
    resources :conversations, only: [:show, :new, :create, :update, :index] do
      get :unread, on: :collection
      resources :messages, only: [:create]
    end 

    resources :users, constraints: { :id=> /[A-Za-z0-9\.]+/ },   only: [:show, :edit, :update, :destroy] do
      get :quotes, on: :member
      get :providers, on: :member
      get :references, on: :member
     end
     
    get :dashboard, to: 'users#dashboard'
    get :settings, to: 'users#settings'
    get :financialsettings, to: 'users#financialsettings'
    get :banned, to: 'users#banned'
    get :verified, to: 'providers#verified' 
    get :about, :to => "pages#about", :as => "about"
    get :how_it_works, :to => "pages#how_it_works", :as => "how_it_works"
    get :how_it_works_provider, :to => "pages#how_it_works_provider", :as => "how_it_works_provider"
    get :contactus, :to => "pages#contactus", :as => "contactus"
    get :policy, :to => "pages#policy", :as => "policy"
    get :terms, :to => "pages#terms", :as => "terms"
    get :blog, :to => "pages#blog", :as => "blog"
    get :faq, :to => "pages#faq", :as => "faq"
    get :contact, :to => "pages#contact", :as => "contact" 

  end
 
  namespace :admin do
    resources :users  do
      get :login_as, on: :member
      post :ban, :unban, on: :member
      post :manualcredits, on: :member
      get :manualcredits, on: :member
      put :addcredit, on: :member
      get :addcredit, on: :member
      post :refunds, on: :member
      get :refunds, on: :member
    end
    resources :providers, only: [:index] do
      post :verify, :unverify, on: :member
    end  

  end

  resources :sessions, only: [:create, :destroy, :new, :failure] 
  get 'auth/:provider', to: 'sessions#new', as: :auth_at_provider
  get 'auth/:provider/callback', to: 'sessions#create'
  post '/auth/:provider/callback' => 'sessions#create'
  get 'auth/failure', :to => 'sessions#failure'
  get 'signout', to: 'sessions#destroy', as: :logout 
  resources :identities
  post "identites/new", to: "identities#new"
  #post 'auth/:provider/register', to: 'sessions#create'
  resources :password_resets
 


  
  get :fbjssdk_channel, to: 'pages#fbjssdk_channel' 
end
