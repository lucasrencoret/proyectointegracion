class BodegaController < ApplicationController
    def index
     
    end
    def consultar
        response = Bodega.consultar(params[:sku])
        render :json => response
    end
    def recibirOc
    
       render :json => { "aceptado" => true , "idoc" => params[:idoc] }
      
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
   def 
end
