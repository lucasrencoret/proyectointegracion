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
       if ( (sku == 20 && precioU >= 1612) || (sku == 46 && precioU >= 8514) || (sku == 48 && precioU >= 6627) || (sku == 56 && precioU >= 5052))
        preciocorrecto =true
       end
       
       if (stock >= cantidad && proveedor="571262b8a980ba030058ab57" && preciocorrecto =true)
            Oc.recepcionarOc(params[:idoc])
            factura = Factura.emitirFactura(params[:idoc])
            idFac = factura['_id']
            numGrupo = B2b.obtenerGrupo(params[:idoc])
            thread.new do
            buffer = open('http://integra'+numGrupo.to_s+'.ing.puc.cl/api/facturas/'+ idFac.to_s , "Content-Type"=>"application/json").read
	        resultado = JSON.parse(buffer)
       #     ActiveRecord::Base.connection.close
            end
            render :json => { "aceptado" => true , "idoc" => params[:idoc] }
            
            
       else
            render :json => { "aceptado" => false , "idoc" => params[:idoc] }
       end
            
   end
   def entregarCuenta
        render :json => { "idGrupo" => "571262b8a980ba030058ab57" , "idCuentaBanco" => "571262c3a980ba030058ab66" }
         
   end
  
   def recibirFactura
      facturaRecibida = Factura.obtenerFactura(params[:idfactura]).first #obtengo factura
      grupoId = facturaRecibida['proveedor'] # id del grupo proveedor
      monto = facturaRecibida['total'] # cuanto le tengo que pagar al proveedor
      numeroGrupo = B2b.obtenerGrupo(grupoId) # numero del grupo proveedor
      idBanco = B2b.obtenerBanco(grupoId) # banco del grupo proveedor
      transferencia = Banco.transferir(monto,"571262c3a980ba030058ab5e",idBanco) #le pago al proveedor
      idTransaccion = transferencia['idtrx'] 
      facturaId = params[:idfactura]
      Factura.pagarFactura(params[:idfactura]) 
      thread.new do
      buffer = open('http://integra'+numeroGrupo.to_s+'.ing.puc.cl/api/pagos/recibir/'+idTransaccion.to_s+"?idfactura="+ facturaId.to_s , "Content-Type"=>"application/json").read
      end
      
      render :json => { "validado" => true , "idfactura" => params[:idfactura] }

   end
   def recibirTransaccion 
   
      render :json => { "validado" => true , "idtrx" => params[:idtrx] }
   end
   
   
   def idAlmacen
   
       almacenes = Bodega.getAlmacenes()

	   almacenes.each do |almacen|
	     if almacen['recepcion'] == true
			
            render :json =>{ "id" => almacen['_id']}
	     end
     end
   end

	    
   def confirmarDespacho
   #ocRevisar = Oc.obtenerfactura(params[:idfactura]).first
   #idoc = ocRevisar['oc']
   #response = Oc.getOc(params[idoc]).first
   #sku = response['sku']
   #bodegas = Bodega.consultar(sku)
   #cantidadEnBodega = bodegas['stock'].to_i
   #cantidadEnOc 
   end
   
   
end
