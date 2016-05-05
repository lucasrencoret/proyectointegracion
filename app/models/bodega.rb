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
def self.idAlmacenDespacho ()
   	response = ""
       almacenes = Bodega.getAlmacenes()

	   almacenes.each do |almacen|
	   if almacen['despacho'] == true	
            response = almacen["_id"]
	   end
	   end
	   response
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
	response = RestClient.post 'http://integracion-2016-dev.herokuapp.com/bodega/moveStock', {:productoId => productoid, :almacenId => almacenid}.to_json, :Authorization => autorizacion, :content_type=> 'application/json'
	resultado = JSON.parse(response)
end

def self.moveStockBodega(productoid,almacenid, oc, precio) #Almacén de recepción de la bodega del grupo de destino
	autorizacion =crear_string("POST"+productoid+almacenid)
	response = RestClient.post 'http://integracion-2016-dev.herokuapp.com/bodega/moveStockBodega', {:productoId => productoid, :almacenId => almacenid}.to_json, :Authorization => autorizacion, :content_type=> 'application/json'
	resultado = JSON.parse(response)
end

def self.despacharStock()
	#DELETEproductoId, direccion, precio, oc
	oc= '572789c5c1ff9b0300017d44'
	precio= '2'
	direccion= '571262b8a980ba030058ab54'
	productId= '571262b7a980ba030058a863'
	header = crear_string("DELETE"+productId+direccion+precio+oc)
	#RestClient.delete 'http://integracion-2016-dev.herokuapp.com/bodega/stock', {:productId => productId, :direccion => direccion, :precio => precio, :oc => oc}.to_json, :Authorization => header, :content_type=> 'application/json'
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
	stringSku = sKu.to_s
	stringCantidad = cAntidad.to_s
	autorizacion =crear_string("PUT"+stringSku+stringCantidad+trxid)
	response = RestClient.put 'http://integracion-2016-dev.herokuapp.com/bodega/fabrica/fabricar', {:sku => sKu, :trxId => trxid, :cantidad => cAntidad}.to_json, :Authorization => autorizacion, :content_type=> 'application/json'
	resultado = JSON.parse(response)
end

def self.getCuentaFabrica () #entrega la cuenta id de la fabrica 
	header = crear_string("GET")
	buffer = open('http://integracion-2016-dev.herokuapp.com/bodega/fabrica/getCuenta', "Content-Type"=>"application/json", "Authorization" => header).read
	resultado = JSON.parse(buffer)
end
def self.abastecerCacao(lotes)
	loTes = lotes.to_i
	cantidad = 60*loTes
	precioCacao = 1280*cantidad
	sku = 20
	trx = pagarFabricacion(precioCacao)
	producirStock(sku, trx, cantidad)
end

def self.revisarMaterialesChocolate(lotes)
	loTes = lotes.to_i
	cacao = getStockProducto("20")
	azucar = getStockProducto("25")
	leche = getStockProducto("7")
	hayCacao = false
	hayAzucar = false
	hayLeche = false
	if(cacao >= 296*loTes)
		hayCacao = true
	end 
	if(azucar >=269*loTes)
		hayAzucar = true
	end
	if(leche >= 251*loTes)
		hayLeche = true
	end
	resultado = {:cacao => hayCacao, :azucar => hayAzucar, :leche => hayLeche}.to_json
	response = JSON.parse(resultado)
end	

def self.revisarMaterialesPasta(lotes)
	loTes = lotes.to_i
	semola = getStockProducto("19")
	sal = getStockProducto("26")
	huevo = getStockProducto("2")
	haySemola = false
	haySal = false
	hayHuevo = false
	if(semola >= 160*loTes)
		haySemola = true
	end 
	if(sal >=172*loTes)
		haySal = true
	end
	if(huevo >= 155*loTes)
		hayHuevo = true
	end
	resultado = {:semola => haySemola, :sal => haySal, :huevo => hayHuevo}.to_json
	response = JSON.parse(resultado)
end	
def self.revisarMaterialesHamb(lotes)
	loTes = lotes.to_i
	semola = getStockProducto("1")
	sal = getStockProducto("26")
	haySal = false
	hayPollo = false
	if(semola >= 935*loTes)
		hayPollo = true
	end 
	if(sal >=65*loTes)
		haySal = true
	end
	
	resultado = {:pollo => hayPollo, :sal => haySal}.to_json
	response = JSON.parse(resultado)
end	
	
def self.moverInsumo(sKu,cantidad)
	almacenes = getAlmacenes()
	totalMovidos = 0
	despacho = idAlmacenDespacho
	almacenes.each do |almacen|
		if almacen['despacho'] == false
			todos_los_productos = getStock(almacen['_id'],sKu)
			todos_los_productos.each do |producto|
			if(totalMovidos<cantidad.to_i)
			moveStock(producto['_id'],despacho)
			totalMovidos+=1
			end
			end
		end
	end	
		
end
def self.producirChocolate(lotes)
	moverInsumo()
	loTes = lotes.to_i
	cantidad = 800*loTes
	precioChoco = 2372*cantidad
	sku = 46
	trx = pagarFabricacion(precioChoco)
	producirStock(sku, trx, cantidad)
end
def self.pagarFabricacion(precio)
	jsonCuenta = getCuentaFabrica()
	idCuentaF = jsonCuenta['cuentaId']
	response = Banco.transferir(precio,"571262c3a980ba030058ab66",idCuentaF)
	response["_id"]
	
end

	
end

