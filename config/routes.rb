Timetraq::Application.routes.draw do

  get "admin/index"

  get "home/index"
  get "home/tutorial"
  post "home/guest"

  devise_for :users

  resources :users, :only => [:show, :destroy] do
    member do
      get 'change_date'
    end
    
    resource :profiles
    
    resources :projects do
      resources :goals, :only=>['new'] #only for the resource url, passing the project to the goal
    end

    resources :activities do
      resources :components
      resources :entries
    end
    
    resources :assignments do
      resources :components
      resources :entries
    end
    
    resources :contacts
    
    resources :goals
    resources :tags
  end
  
  resources :groups
  
  resources :projects, :only=>['show'] do
    member do
      get 'search'
    end
    
    resources :goals, :only=>['show'] do
      resources :activities, :only=>['show']
      
      resources :assignments, :only=>['show']
      
      resources :components, :only=>['show']
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'
  # root :to => 'users#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
