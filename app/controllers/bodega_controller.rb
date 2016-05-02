class BodegaController < ApplicationController
    def index
     
    end
    def consultar
        
        response = Bodega.consultar(params[:sku])
    end
    
end
