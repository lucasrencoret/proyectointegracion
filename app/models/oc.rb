require 'open-uri'
require 'rubygems'
require 'rest-client'
class Oc < ActiveRecord::Base
#attr_accessible :name
def self.getOc(id)
    
	if Rails.env.production?
    	buffer = open('http://moto.ing.puc.cl/oc/obtener/'+id , "Content-Type"=>"application/json").read
    else
      	buffer = open('http://mare.ing.puc.cl/oc/obtener/'+id , "Content-Type"=>"application/json").read
  	end

    resultado = JSON.parse(buffer)
    
end
def self.recepcionarOc(iD)
	
	if Rails.env.production?
		response = RestClient.post 'http://moto.ing.puc.cl/oc/recepcionar/'+iD, {:id => iD}.to_json, :content_type=> 'application/json'
	else
		response = RestClient.post 'http://mare.ing.puc.cl/oc/recepcionar/'+iD, {:id => iD}.to_json, :content_type=> 'application/json'		
	end

	resultadoEnJson = JSON.parse(response)
end
def self.rechazarOc(iD,motivo)
	
	if Rails.env.production?
		response = RestClient.post 'http://moto.ing.puc.cl/oc/rechazar/'+iD, {:rechazo =>motivo}.to_json, :content_type=> 'application/json'
	else
		response = RestClient.post 'http://mare.ing.puc.cl/oc/rechazar/'+iD, {:rechazo =>motivo}.to_json, :content_type=> 'application/json'
	end

	resultadoEnJson = JSON.parse(response)
end
def self.crearOc(cAnal, cAntidad, skuid, pRoveedor, pRecioUnitario, nOtas, cLiente, fEchaEntrega)
	
	if Rails.env.production?
		response = RestClient.put 'http://moto.ing.puc.cl/oc/crear', {:canal => cAnal, :cantidad => cAntidad, :sku => skuid, :proveedor => pRoveedor, :precioUnitario => pRecioUnitario, :notas => nOtas, :cliente => cLiente, :fechaEntrega => fEchaEntrega}.to_json, :content_type=> 'application/json'
	else
		response = RestClient.put 'http://mare.ing.puc.cl/oc/crear', {:canal => cAnal, :cantidad => cAntidad, :sku => skuid, :proveedor => pRoveedor, :precioUnitario => pRecioUnitario, :notas => nOtas, :cliente => cLiente, :fechaEntrega => fEchaEntrega}.to_json, :content_type=> 'application/json'
	end

	resultadoEnJson = JSON.parse(response)
end


end