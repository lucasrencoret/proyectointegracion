require 'open-uri'
require 'rubygems'
require 'rest-client'

class Factura < ActiveRecord::Base
def self.obtenerFactura(id)
	
	#if Rails.env.production?
		buffer = open('http://moto.ing.puc.cl/facturas/'+id , "Content-Type"=>"application/json").read
	#else
	#	buffer = open('http://mare.ing.puc.cl/facturas/'+id , "Content-Type"=>"application/json").read
	#end

	resultado = JSON.parse(buffer)

end
def self.emitirFactura(oC)
	
	#if Rails.env.production?
		response = RestClient.put 'http://moto.ing.puc.cl/facturas/', {:oc => oC}.to_json, :content_type=> 'application/json'
	#else
	#	response = RestClient.put 'http://mare.ing.puc.cl/facturas/', {:oc => oC}.to_json, :content_type=> 'application/json'
	#end

	resultadoEnJson = JSON.parse(response)
end
def self.pagarFactura(iD)
	
	#if Rails.env.production?
		response = RestClient.post 'http://moto.ing.puc.cl/facturas/pay', {:id => iD}.to_json, :content_type=> 'application/json'
	#else
	#	response = RestClient.post 'http://mare.ing.puc.cl/facturas/pay', {:id => iD}.to_json, :content_type=> 'application/json'
	#end

	resultadoEnJson = JSON.parse(response)
end
def self.rechazarFactura(iD,motiv)
	
	#if Rails.env.production?
		response = RestClient.post 'http://moto.ing.puc.cl/facturas/reject', {:id => iD, :motivo => motiv}.to_json, :content_type=> 'application/json'
	#else
	#	response = RestClient.post 'http://mare.ing.puc.cl/facturas/reject', {:id => iD, :motivo => motiv}.to_json, :content_type=> 'application/json'
	#end

	resultadoEnJson = JSON.parse(response)
end
def self.anularFactura(iD,motiv)
	
	#if Rails.env.production?
		response = RestClient.post 'http://moto.ing.puc.cl/facturas/cancel', {:id => iD, :motivo => motiv}.to_json, :content_type=> 'application/json'
	#else
	#	response = RestClient.post 'http://mare.ing.puc.cl/facturas/cancel', {:id => iD, :motivo => motiv}.to_json, :content_type=> 'application/json'
	#end

	resultadoEnJson = JSON.parse(response)
end

def self.crearBoleta(proveed, cliente, total)
	
	#if Rails.env.production?
		response = RestClient.put 'http://moto.ing.puc.cl/facturas/boleta', {:proveedor => proveed, :cliente => cliente, :total => total}.to_json, :content_type=> 'application/json'
	#else
	#	response = RestClient.put 'http://mare.ing.puc.cl/facturas/boleta', {:proveedor => proveed, :cliente => cliente, :total => total}.to_json, :content_type=> 'application/json'
	#end	

	resultadoEnJson = JSON.parse(response)
end



end
