require 'rubygems'
require 'base64'
require 'cgi'
require 'hmac-sha1'
require 'openssl'
require 'base64'
require 'digest'
require 'open-uri'
require 'rest-client'
#<<<<<<< HEAD
#=======
require 'net/http'
require 'uri'
#>>>>>>> aeb959def17b8df93deabb0e059bd98967e6960a

class Bodega < ActiveRecord::Base


def self.encrypt(texto)
	key = texto
	data = 'WqhY79mm3N4ph6'
	OpenSSL::HMAC.digest('SHA1',data,key)
	Base64.encode64 OpenSSL::HMAC.digest('SHA1',data,key)


end

def self.crear_string(data)
	string_hash = "INTEGRACION grupo9:"
	header_agregar = string_hash+encrypt(data)
end	
	
def self.getAlmacenes () #entrega informacion sobre los almacenes de la bodega solicitada
	header = crear_string("GET")
	buffer = open('http://integracion-2016-dev.herokuapp.com/bodega/almacenes', "Content-Type"=>"application/json", "Authorization" => header).read
	resultado = JSON.parse(buffer)
	
	#resultado.each do |bodega|
	#	puts "#{bodega['_id']}\t#{bodega['grupo']}\t#{bodega['pulmon']}\t#{bodega['despacho']}\t#{bodega['recepcion']}\t#{bodega['totalSpace']}\t#{bodega['usedSpace']}\t"
	#end
	
	
	#rest-open-uri para hacer posts

end

def self.getSkusWithStock(almacenId)
	header = crear_string("GET" + almacenId)
	buffer = open('http://integracion-2016-dev.herokuapp.com/bodega/skusWithStock?almacenId='+almacenId , "Content-Type"=>"application/json", "Authorization" => header).read
	resultado = JSON.parse(buffer)

end

def self.getStock(almacenId, sku) #devuelve todos los productos de un sku que estan en un almacen
	header = crear_string("GET"+almacenId+sku)
	buffer = open('http://integracion-2016-dev.herokuapp.com/bodega/stock?almacenId='+almacenId+"&sku="+sku, "Content-Type"=>"application/json", "Authorization" => header).read
	resultado = JSON.parse(buffer)


end

def self.getCuentaFabrica () #entrega la cuenta id de la fabrica 
	header = crear_string("GET")
	buffer = open('http://integracion-2016-dev.herokuapp.com/bodega/fabrica/getCuenta', "Content-Type"=>"application/json", "Authorization" => header).read
	resultado = JSON.parse(buffer)
end

def self.consultar(sku_request)
	
	#sku_request = params[:sku] o por parametro de metodo
	stock = getStockProducto(sku_request)
	JSON.parse({:stock => stock, :sku => sku_request}.to_json)
end

def self.getStockProducto(sku_request)
	stock = 0
	almacenes = getAlmacenes()

	almacenes.each do |almacen|
		todos_los_skus = getSkusWithStock(almacen['_id'])
		todos_los_skus.each do |sku|
			if (sku['_id']== sku_request)
				stock+=sku['total']
			end
		end
		
	end
	stock
end
def self.moveStock(productoid,almacenid) #almacen de destino
	autorizacion =crear_string("POST"+productoid+almacenid)
	RestClient.post 'http://integracion-2016-dev.herokuapp.com/bodega/moveStock', {:productoId => productoid, :almacenId =>almacenid}.to_json, :Authorization => autorizacion, :content_type=> 'application/json'
end

def self.moveStockBodega(productoid,almacenid, oc, precio) #Almacén de recepción de la bodega del grupo de destino
	autorizacion =crear_string("POST"+productoid+almacenid)
	RestClient.post 'http://integracion-2016-dev.herokuapp.com/bodega/moveStockBodega', {:productoId => productoid, :almacenId =>almacenid}.to_json, :Authorization => autorizacion, :content_type=> 'application/json'
end

def self.stock()
	
	
	
end


end



