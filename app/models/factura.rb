require 'open-uri'
require 'rubygems'
require 'rest-client'

class Factura < ActiveRecord::Base
def self.obtenerFactura(id)
	buffer = open('http://mare.ing.puc.cl/facturas/'+id , "Content-Type"=>"application/json").read
	resultado = JSON.parse(buffer)

end
def self.pagarFactura(iD)
	
	RestClient.post 'http://mare.ing.puc.cl/facturas/pay', {:id => iD}.to_json, :content_type=> 'application/json'
	
end
def self.rechazarFactura(iD,motiv)
	
	RestClient.post 'http://mare.ing.puc.cl/facturas/reject', {:id => iD, :motivo =>motiv}.to_json, :content_type=> 'application/json'
	
end
def self.anularFactura(iD,motiv)
	
	RestClient.post 'http://mare.ing.puc.cl/facturas/cancel', {:id => iD, :motivo =>motiv}.to_json, :content_type=> 'application/json'
	
end

end
