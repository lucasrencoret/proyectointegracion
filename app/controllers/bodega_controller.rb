class BodegaController < ApplicationController
    def index
     
    end
    def consultar
        response = Bodega.consultar(params[:sku])
        render :json => response
    end
    def recibirOc
       response = Oc.getOc(params[:idoc]).first
     
       cantidad = response['cantidad']
       proveedor = response['proveedor']
       precioU = response['precioUnitario']
       sku = response['sku']
       stock = Bodega.consultar(sku)['stock']
       preciocorrecto = false
       if ( (sku = 20 && precioU = 1612) || (sku = 46 && precioU = 8514) || (sku = 48 && precioU = 6627) || (sku = 56 && 5052))
        preciocorrecto =true
       end
            
       if (stock >= cantidad && proveedor="571262b8a980ba030058ab57" && preciocorrecto =true)
            Oc.recepcionarOc(params[:idoc])
            render :json => { "aceptado" => true , "idoc" => params[:idoc] }
            
       else
            render :json => { "aceptado" => false , "idoc" => params[:idoc] }
       end
       
       
   end
   def entregarCuenta
        render :json => { "idGrupo" => "571262b8a980ba030058ab57" , "idCuentaBanco" => "571262c3a980ba030058ab66" }
         
   end
   def recibirFactura
   
      render :json => { "validado" => true , "idfactura" => params[:idfactura] }
   end
    def recibirTransaccion 
   
      render :json => { "validado" => true , "trx" => params[:idtrx] }
   end
   
   def entregarDespacho 
   
   end
   
   def idAlmacen
   
       almacenes = Bodega.getAlmacenes()

	   almacenes.each do |almacen|
	   if almacen['recepcion'] == true
			
            render :json =>{ "id" => almacen['_id']}
	   end
       end
	    
   
   end
   
   
end
