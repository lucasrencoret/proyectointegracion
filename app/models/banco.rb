require 'open-uri'
require 'rubygems'
require 'rest-client'

class Banco < ActiveRecord::Base
def self.obtenerCuenta(cuentaId)
	
	#if Rails.env.production?
		buffer = open('http://moto.ing.puc.cl/banco/cuenta/'+cuentaId , "Content-Type"=>"application/json").read
	#else
	#	buffer = open('http://mare.ing.puc.cl/banco/cuenta/'+cuentaId , "Content-Type"=>"application/json").read
	#end

	resultado = JSON.parse(buffer)

end

def self.ingresar_cuenta()
	cuenta = obtenerCuenta("572aac69bdb6d403005fb057").first #en produccion
	estado_cuenta = cuenta['saldo']
	Cuentum.create(:saldo => estado_cuenta)

end
def self.obtenerTransaccion(id)
	
	#if Rails.env.production?
	#	buffer = open('http://moto.ing.puc.cl/banco/trx/'+id , "Content-Type"=>"application/json").read
	#else
		buffer = open('http://mare.ing.puc.cl/banco/trx/'+id , "Content-Type"=>"application/json").read
	#end

	resultado = JSON.parse(buffer)

end
def self.obtenerCartola(fechainicio,fechafin,iD)
	
	#if Rails.env.production?
	#	response = RestClient.post 'http://moto.ing.puc.cl/banco/cartola', {:fechaInicio => fechainicio, :fechaFin => fechafin, :id => iD}.to_json, :content_type=> 'application/json'
	#else
		response = RestClient.post 'http://mare.ing.puc.cl/banco/cartola', {:fechaInicio => fechainicio, :fechaFin => fechafin, :id => iD}.to_json, :content_type=> 'application/json'
	#end
	
	resultadoEnJson = JSON.parse(response)
end
def self.transferir(moNto,oRigen,dEstino)
	
	#if Rails.env.production?
	#	response = RestClient.put 'http://moto.ing.puc.cl/banco/trx/' , {:origen => oRigen, :destino => dEstino, :monto => moNto}.to_json, :content_type=> 'application/json'
	#else
		response = RestClient.put 'http://mare.ing.puc.cl/banco/trx/' , {:origen => oRigen, :destino => dEstino, :monto => moNto}.to_json, :content_type=> 'application/json'		
	#end

	resultadoEnJson = JSON.parse(response)
end
end
