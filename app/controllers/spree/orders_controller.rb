module Spree
  class OrdersController < Spree::StoreController
    before_action :check_authorization
    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    helper 'spree/products', 'spree/orders'

    respond_to :html

    before_action :assign_order_with_lock, only: :update
    skip_before_action :verify_authenticity_token, only: [:populate]

    def show
      @order = Order.includes(line_items: [variant: [:option_values, :images, :product]], bill_address: :state, ship_address: :state).find_by_number!(params[:id])
    end

    def update
      if @order.contents.update_cart(order_params)
        respond_with(@order) do |format|
          format.html do
            if params.has_key?(:checkout)
              @order.next if @order.cart?
              redirect_to checkout_state_path(@order.checkout_steps.first)
            else
              redirect_to cart_path
            end
          end
        end
      else
        respond_with(@order)
      end
    end

    # Shows the current incomplete order from the session
    def edit
      @order = current_order || Order.incomplete.
                                  includes(line_items: [variant: [:images, :option_values, :product]]).
                                  find_or_initialize_by(guest_token: cookies.signed[:guest_token])
      associate_user
    end

    # Adds a new item to the order (creating a new order if none already exists)
    def populate
      order    = current_order(create_order_if_necessary: true)
      variant  = Spree::Variant.find(params[:variant_id])
      quantity = params[:quantity].to_i
      options  = params[:options] || {}
      direccion = params[:direccion]
      cliente = params[:name]
      sku = params[:sku]
      
      

      # 2,147,483,647 is crazy. See issue #2695.
      if quantity.between?(1, 2_147_483_647)
        
      else
        error = Spree.t(:please_enter_reasonable_quantity)
      end

      if error
        flash[:error] = error
        redirect_back_or_default(spree.root_path)
      else
        total = 0;
        if(sku.to_i == 20)
          total = 1612*quantity
        elsif (sku.to_i == 46)
          total = 8514*quantity
        elsif (sku.to_i == 48)
          total = 6627*quantity
        else
          total = 5052*quantity
        end
        # 572aac69bdb6d403005fb04a produccion. 571262b8a980ba030058ab57 desarrollo.
        respuesta = Factura.crearBoleta("572aac69bdb6d403005fb04a", cliente, total)
        #respuesta = Factura.crearBoleta("571262b8a980ba030058ab57", cliente, total)
        respuesta_model = B2c.create(:cliente => respuesta['cliente'], :proveedor => respuesta['proveedor'], :bruto => respuesta['bruto'], :iva => respuesta['iva'], :total => respuesta['total'], :_id => respuesta['_id'], :estado => respuesta['estado'], :direccion => direccion, :sku => sku, :cantidad => quantity)
        puts respuesta_model
        
        url_ok = "http%3A%2F%2Fintegra9.ing.puc.cl/tienda/ok/"+respuesta['_id']
        url_fail = "http%3A%2F%2Fintegra9.ing.puc.cl/tienda/fail/"
        url = "http://integracion-2016-prod.herokuapp.com/web/pagoenlinea?callbackUrl="+url_ok+"&cancelUrl="+url_fail+"+&boletaId="+respuesta['_id']
        #url_ok = "localhost:3000/tienda/ok/"+respuesta['_id']
        #url_fail = "localhost:3000/tienda/fail/"
        #url = "http://integracion-2016-dev.herokuapp.com/web/pagoenlinea?callbackUrl="+url_ok+"&cancelUrl="+url_fail+"+&boletaId="+respuesta['_id']
        
        redirect_to url
      end
    
    end

    def empty
      if @order = current_order
        @order.empty!
      end

      redirect_to spree.cart_path
    end

    def accurate_title
      if @order && @order.completed?
        Spree.t(:order_number, :number => @order.number)
      else
        Spree.t(:shopping_cart)
      end
    end

    def check_authorization
      order = Spree::Order.find_by_number(params[:id]) || current_order

      if order
        authorize! :edit, order, cookies.signed[:guest_token]
      else
        authorize! :create, Spree::Order
      end
    end

    private

      def order_params
        if params[:order]
          params[:order].permit(*permitted_order_attributes)
        else
          {}
        end
      end

      def assign_order_with_lock
        @order = current_order(lock: true)
        unless @order
          flash[:error] = Spree.t(:order_not_found)
          redirect_to root_path and return
        end
      end
  end
end
