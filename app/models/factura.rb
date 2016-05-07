require 'open-uri'
require 'rubygems'
require 'rest-client'

class Factura < ActiveRecord::Base
def self.obtenerFactura(id)
	buffer = open('http://mare.ing.puc.cl/facturas/'+id , "Content-Type"=>"application/json").read
	resultado = JSON.parse(buffer)

end
def self.emitirFactura(oC)
	
	response = RestClient.put 'http://mare.ing.puc.cl/facturas/', {:oc => oC}.to_json, :content_type=> 'application/json'
	resultadoEnJson = JSON.parse(response)
end
def self.pagarFactura(iD)
	
	response = RestClient.post 'http://mare.ing.puc.cl/facturas/pay', {:id => iD}.to_json, :content_type=> 'application/json'
	resultadoEnJson = JSON.parse(response)
end
def self.rechazarFactura(iD,motiv)
	
	response = RestClient.post 'http://mare.ing.puc.cl/facturas/reject', {:id => iD, :motivo => motiv}.to_json, :content_type=> 'application/json'
	resultadoEnJson = JSON.parse(response)
end
def self.anularFactura(iD,motiv)
	
	response = RestClient.post 'http://mare.ing.puc.cl/facturas/cancel', {:id => iD, :motivo => motiv}.to_json, :content_type=> 'application/json'
	resultadoEnJson = JSON.parse(response)
end

def self.crearBoleta(proveed, cliente, total)
	
	RestClient.put 'http://mare.ing.puc.cl/facturas/boleta', {:proveedor => proveed, :cliente => cliente, :total => total}.to_json, :content_type=> 'application/json'
	
end



end
