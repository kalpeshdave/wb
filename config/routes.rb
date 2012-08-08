ActionController::Routing::Routes.draw do |map|
  map.resource :user_session
  map.resources :password_resets, :only => [ :new, :create, :edit, :update]
  map.secret '/password_reset/secret', :controller => "password_resets", :action => "secret"

  map.edit_address '/companies/:id/edit_address/:address_id', :controller => "companies", :action => 'edit_address', :conditions => { :method => :get }
  map.update_address '/companies/:id/update_address/:address_id', :controller => "companies", :action => 'update_address', :conditions => { :method => :put }

  map.resources :companies,
    :member => {
    :change         => :get,
    :delete_address => :get,
    
  }
  map.use_company '/compnaies/:id/use', :controller => "companies", :action => "use"
  map.resource :account, :controller => "users"
  map.resources :contract_templates
  
  map.resources :users, :member => { 
    :user_access          => :get,
    :delete_skill         => :get,
    :delete_phone_number  => :get,
    :delete_attachment    => :get,
    :download_file        => :get,
    :delete_allow_block   => :get,
    :edit_address         => :get,
    :update_address       => :put,
    :delete_address       => :get
  }, :collection => {
    :address_new          => :get,
    :address_create       => :post,
    :add_user_access_list => :get
  } do |u|
    u.resource :contract_preference, :member => {:get_time_units => :get }
    u.resource :timesheet_preference, :member => {:get_time_units => :get }
  end

  map.resources :user_addresses
  
  map.resources :search_contracts, :collection => {:sent_mail => :get}
  map.resources :search_contractors, :collection => {:sent_mail => :get}

  map.signup '/signup', :controller => 'users', :action => 'new', :conditions => { :method => :get }
  map.login '/login', :controller => "user_sessions", :action => "new", :conditions => { :method => :get }
  map.contact_info '/contact_information', :controller => 'users', :action => 'contact_info', :conditions => { :method => :get }
  map.password_settings '/password_settings', :controller => 'users', :action => 'password_settings'
  map.update_password '/update_password/:id', :controller => 'users', :action => 'update_password'
  map.update_contact_info '/update_contact_information/:id', :controller => 'users', :action => 'update_contact_info', :conditions => { :method => :put }
  map.recipient_detail "/recipient_detail", :controller => 'contracts', :action => 'recipient_detail', :conditions => { :method => :get }

  map.new_timesheet_option '/sub_contracts/:contract_id/new_timesheet_option', :controller => 'sub_contracts', :action => 'new_timesheet_option', :conditions => { :method => :get }
  map.create_timesheet_option '/sub_contracts/:contract_id/create_timesheet_option', :controller => 'sub_contracts', :action => 'create_timesheet_option', :conditions => { :method => :post }
  
  map.resources :contracts,
    :member => {
      :download_file            => :get,
      :approve_reject           => :put,
      :recepient_reason         => :get,
      :delete_attachment        => :get,
      :get_recipients           => :get,
      :get_clients              => :get,
      :recipient_create         => :get,
      :update_is_template       => :get,
      :get_time_units           => :get
      #:timesheet_option         => :get,
      #:update_timesheet_option  => :put
    } do |contract|
    contract.resources :propose_contracts
    contract.resources :sub_contracts
    contract.resource :timesheet_option
  end
  
  map.resources :timesheets, 
    :member => {
      :pdf                => :get,
      :get_time_units     => :get,
      :approve_reject     => :put,
      :recepient_reason   => :get
   }, :collection => {
     :fetch_contract_values => :get
   }
  map.resource :contract_dashboard
  map.resource :timesheet_dashboard

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  #   map.root :controller => "welcome"
  map.root :controller => "user_sessions", :action => "new"

  # See how all your routes lay out with "rake routes"
  map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
  map.activate '/activate/:id', :controller => 'activations', :action => 'create'

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
