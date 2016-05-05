require 'open-uri'
require 'rubygems'
require 'rest-client'
class Oc < ActiveRecord::Base
def self.getOc(id)
    buffer = open('http://mare.ing.puc.cl/oc/obtener/'+id , "Content-Type"=>"application/json").read
    resultado = JSON.parse(buffer)
    
end
def self.recepcionarOc(iD)
	
	response = RestClient.post 'http://mare.ing.puc.cl/oc/recepcionar/'+iD, {:id => iD}.to_json, :content_type=> 'application/json'
	resultadoEnJson = JSON.parse(response)
end
def self.rechazarOc(iD,motivo)
	response = RestClient.post 'http://mare.ing.puc.cl/oc/rechazar/'+iD, {:rechazo =>motivo}.to_json, :content_type=> 'application/json'
	resultadoEnJson = JSON.parse(response)
end
def self.crearOc(cAnal, cAntidad, skuid, pRoveedor, pRecioUnitario, nOtas, cLiente, fEchaEntrega)
	
	response = RestClient.put 'http://mare.ing.puc.cl/oc/crear', {:canal => cAnal, :cantidad => cAntidad, :sku => skuid, :proveedor => pRoveedor, :precioUnitario => pRecioUnitario, :notas => nOtas, :cliente => cLiente, :fechaEntrega => fEchaEntrega}.to_json, :content_type=> 'application/json'
	resultadoEnJson = JSON.parse(response)
end
end