require 'open-uri'
require 'rubygems'
require 'rest-client'

class Banco < ActiveRecord::Base
def self.obtenerCuenta(cuentaId)
	buffer = open('http://mare.ing.puc.cl/banco/cuenta/'+cuentaId , "Content-Type"=>"application/json").read
	resultado = JSON.parse(buffer)

end
def self.obtenerTransaccion(id)
	buffer = open('http://mare.ing.puc.cl/banco/trx/'+id , "Content-Type"=>"application/json").read
	resultado = JSON.parse(buffer)

end
def self.obtenerCartola(fechainicio,fechafin,iD)
	
	RestClient.post 'http://mare.ing.puc.cl/banco/cartola', {:fechaInicio => fechainicio, :fechaFin => fechafin, :id => iD}.to_json, :content_type=> 'application/json'
	
end
def self.transferir(moNto,oRigen,dEstino)
	RestClient.put 'http://mare.ing.puc.cl/banco/trx/' , {:monto => moNto, :origen => oRigen, :destino => dEstino}.to_json, :content_type=> 'application/json'
	
end
end
