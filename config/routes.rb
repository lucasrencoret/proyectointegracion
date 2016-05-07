Rails.application.routes.draw do
  get 'home/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  get 'api/consultar/:sku' => 'bodega#consultar'
  get 'api/bodega/consultar/:sku' => 'bodega#consultar' #por si se equivocan y ponen bodega, los manda igual
  get 'api/oc/recibir/:idoc' => 'bodega#recibirOc'
  get 'api/facturas/recibir/:idfactura' => 'bodega#recibirFactura'
  get 'api/pagos/recibir/:idtrx?idfactura=:idfactura' => 'bodega#recibirTransaccion'
  get 'api/datos' => 'bodega#entregarCuenta'
  get 'api/despachos/recibir/:idfactura' => 'bodega#confirmarDespacho'
  get 'api/ids/almacenId' => 'bodega#idAlmacen'

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
