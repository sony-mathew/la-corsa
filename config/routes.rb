LaCorsa::Application.routes.draw do
  devise_for :users

  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/help',    :to => 'pages#help'

  match '/searchCourses',    :to => 'courses#search'
  root :to => 'pages#home'

  
  #resources :courses

  resources :users do
    resources :study_materials
    resources :courses #do
    #   resources :course_materials
    # end
    # resources :learning_processes
  end

  resources :study_materials
  resources :courses

  match '/users/:id/students',    :to => 'learning_processes#students'
  match '/users/:id/courses/enrolled/:status', :to => 'learning_processes#courses'

  match '/drop-course',    :to => 'learning_processes#drop_course'
  match '/activate-course',    :to => 'learning_processes#activate_course'
  match '/enroll-me',    :to => 'learning_processes#enroll_me'
  match '/finished-material',    :to => 'learning_processes#finished_material'
  match '/suggest',    :to => 'learning_processes#suggest_course'
  
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
