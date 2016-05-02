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
end
