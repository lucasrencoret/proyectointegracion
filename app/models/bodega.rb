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



def self.consultar(sku_request)
	
	#sku_request = params[:sku] o por parametro de metodo
	stock = getStockProducto(sku_request)
	JSON.parse({:stock => stock, :sku => sku_request}.to_json)
end

def self.getStockProducto(sku_request)
	stock = 0
	almacenes = getAlmacenes()

	almacenes.each do |almacen|
		if almacen['despacho'] == false
			todos_los_skus = getSkusWithStock(almacen['_id'])
			todos_los_skus.each do |sku|
				if (sku['_id']== sku_request)
					stock+=sku['total']
				end
			end
		end
		
	end
	stock
end
def self.moveStock(productoid,almacenid) #almacen de destino
	autorizacion =crear_string("POST"+productoid+almacenid)
	RestClient.post 'http://integracion-2016-dev.herokuapp.com/bodega/moveStock', {:productoId => productoid, :almacenId => almacenid}.to_json, :Authorization => autorizacion, :content_type=> 'application/json'
end

def self.moveStockBodega(productoid,almacenid, oc, precio) #Almacén de recepción de la bodega del grupo de destino
	autorizacion =crear_string("POST"+productoid+almacenid)
	RestClient.post 'http://integracion-2016-dev.herokuapp.com/bodega/moveStockBodega', {:productoId => productoid, :almacenId => almacenid}.to_json, :Authorization => autorizacion, :content_type=> 'application/json'
end

def self.despacharStock()
	#DELETEproductoId, direccion, precio, oc
	oc= '572789c5c1ff9b0300017d44'
	precio= '2'
	direccion= '571262b8a980ba030058ab54'
	productoId= '571262b7a980ba030058a863'
	header = crear_string("DELETE"+productoId+direccion+precio+oc)
	#RestClient.delete 'http://integracion-2016-dev.herokuapp.com/bodega/stock', {:productoId => productoId, :direccion => direccion, :precio => precio, :oc => oc}.to_json, :Authorization => header, :content_type=> 'application/json'
	#request(Delete.new('http://integracion-2016-dev.herokuapp.com/bodega/stock', {:productoId => productoId, :direccion => direccion, :precio => precio, :oc => oc}.to_json, :Authorization => header, :content_type=> 'application/json'))
	#Net::HTTP::Delete.new( 
	#NET::HTTP::Delete("http://integracion-2016-dev.herokuapp.com/bodega/stock", { :body => 
  #'{"productoId":productoId, "direccion":direccion, "precio":precio, "oc":oc}', :Authorization => header, :content_type=> 'application/json'
#}){:productoId => productoId, :direccion => direccion, :precio => precio, :oc => oc
	#RestClient::Request.execute(method: :delete, url: 'http://integracion-2016-dev.herokuapp.com/bodega/stock',
    #                       body: {:productoId => productoId, :direccion => direccion, :precio => precio, :oc => oc}.to_json, headers: {:Authorization => header, :Content_Type => 'application/json'})
	
	#[{"_id"=>"572789c5c1ff9b0300017d44", "created_at"=>"2016-05-02T17:09:25.369Z", "updated_at"=>"2016-05-02T17:09:25.369Z", "notas"=>"prueba", "cliente"=>"571262b8a980ba030058ab54", "proveedor"=>"571262b8a980ba030058ab57", "sku"=>"20", "estado"=>"aceptada", "fechaDespachos"=>[], "fechaEntrega"=>"2017-05-01T22:38:33.000Z", "precioUnitario"=>2, "cantidadDespachada"=>0, "cantidad"=>1, "canal"=>"b2b", "__v"=>0}]
end

def self.producirStock(sKu, trxid, cAntidad) 
	autorizacion =crear_string("PUT"+sKu+trxid+cAntidad)
	RestClient.put 'http://integracion-2016-dev.herokuapp.com/bodega/fabrica/fabricar', {:sku => sKu, :trxId => trxid, :cantidad => cAntidad}.to_json, :Authorization => autorizacion, :content_type=> 'application/json'

end

def self.getCuentaFabrica () #entrega la cuenta id de la fabrica 
	header = crear_string("GET")
	buffer = open('http://integracion-2016-dev.herokuapp.com/bodega/fabrica/getCuenta', "Content-Type"=>"application/json", "Authorization" => header).read
	resultado = JSON.parse(buffer)
end
def self.abastecerCacao()
end
def self.pagarFabricacion(precio)
	jsonCuenta = getCuentaFabrica.first
	idCuentaF = jsonCuenta['cuentaId']
	response = Banco.transferir(precio,"571262c3a980ba030058ab66",idCuentaF).first
	response['_id']
end
	
end

