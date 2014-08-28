LaCorsa::Application.routes.draw do
  devise_for :users

  #routes related to courses controller
  match '/courses/filter/:courses_filter',            :to => 'courses#index'
  match '/courses/enrolled/:status',                  :to => 'learning_processes#courses'
  match '/study_materials/filter/:materials_filter',  :to => 'study_materials#index'
  match '/students',                                  :to => 'learning_processes#students'

  #routes related to pages controller
  match '/about',   :to => 'pages#about'
  root              :to => 'pages#home'

  resources :study_materials do
    collection do
         get 'search'
       end
  end

  resources :learning_processes do
    collection do
      get 'drop_course'
      get 'activate_course'
      get 'enroll_me'
      get 'finished_material'
      get 'suggest'
      get 'rate_course'
    end
  end  
  #all resources listing
  resources :users do
    resources :study_materials
    resources :courses
  end
  resources :courses


  

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
