require 'rubygems'
require 'base64'
require 'cgi'
require 'hmac-sha1'
require 'openssl'
require 'base64'
require 'digest'
require 'open-uri'

class Bodega < ActiveRecord::Base


def self.encrypt(texto)
	key = texto
	data = 'WqhY79mm3N4ph6'
	OpenSSL::HMAC.digest('SHA1',data,key)
	Base64.encode64 OpenSSL::HMAC.digest('SHA1',data,key)

end

def self.crear_string(request, parametro)
	string_hash = "INTEGRACION grupo9:"
	header_agregar = string_hash+encrypt(request+parametro)
end	
	
def self.getAlmacenes () #entrega informacion sobre los almacenes de la bodega solicitada
	header = crear_string("GET","")
	buffer = open('http://integracion-2016-dev.herokuapp.com/bodega/almacenes', "Content-Type"=>"application/json", "Authorization" => header).read
	resultado = JSON.parse(buffer)
	
	resultado.each do |bodega|
		puts "#{bodega['_id']}\t#{bodega['grupo']}\t#{bodega['pulmon']}\t#{bodega['despacho']}\t#{bodega['recepcion']}\t#{bodega['totalSpace']}\t#{bodega['usedSpace']}\t"
	end
	
	
	#rest-open-uri para hacer posts

end

def getSkusWithStock(almacenId)
	header = crear_string("GET",almacenId)
	buffer = open('http://integracion-2016-dev.herokuapp.com/bodega/skusWithStock', "Content-Type"=>"application/json", "Authorization" => header).read
	resultado = JSON.parse(buffer)
	



end



end



