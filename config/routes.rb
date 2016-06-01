Rails.application.routes.draw do

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, at: '/tienda'
          get 'home/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  get 'api/consultar/:sku' => 'bodega#consultar'
  get 'api/bodega/consultar/:sku' => 'bodega#consultar' #por si se equivocan y ponen bodega, los manda igual
  get 'api/oc/recibir/:idoc' => 'bodega#recibirOc'
  get 'api/facturas/recibir/:idfactura' => 'bodega#recibirFactura'
  # get 'api/pagos/recibir/:idtrx?idfactura=:idfactura' => 'bodega#recibirTransaccion'
  get 'api/pagos/recibir/:idtrx' => 'bodega#recibirTransaccion'
 
  #get 'api/pagos/recibir/:idtrx/:idfactura' => 'bodega#recibirTransaccion'
  get 'api/datos' => 'bodega#entregarCuenta'
  get 'api/despachos/recibir/:idfactura' => 'bodega#confirmarDespacho'
  get 'api/ids/almacenId' => 'bodega#idAlmacen'
  get '/doc' => 'home#doc'
  get '/almacen' => 'home#almacen'
  resources :ocs

  #resources :ocs


  
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
