require 'open-uri'
require 'rubygems'
require 'rest-client'

class Banco < ActiveRecord::Base
def self.obtenerCuenta(cuentaId)
	buffer = open('http://moto.ing.puc.cl/banco/cuenta/'+cuentaId , "Content-Type"=>"application/json").read
	resultado = JSON.parse(buffer)

end
def self.obtenerTransaccion(id)
	buffer = open('http://moto.ing.puc.cl/banco/trx/'+id , "Content-Type"=>"application/json").read
	resultado = JSON.parse(buffer)

end
def self.obtenerCartola(fechainicio,fechafin,iD)
	
	response = RestClient.post 'http://moto.ing.puc.cl/banco/cartola', {:fechaInicio => fechainicio, :fechaFin => fechafin, :id => iD}.to_json, :content_type=> 'application/json'
	resultadoEnJson = JSON.parse(response)
end
def self.transferir(moNto,oRigen,dEstino)
	response = RestClient.put 'http://moto.ing.puc.cl/banco/trx/' , {:origen => oRigen, :destino => dEstino, :monto => moNto}.to_json, :content_type=> 'application/json'
	resultadoEnJson = JSON.parse(response)
end
end
