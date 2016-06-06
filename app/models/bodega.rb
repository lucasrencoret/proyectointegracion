require 'rubygems'
require 'base64'
require 'cgi'
require 'hmac-sha1'
require 'openssl'
require 'base64'
require 'digest'
require 'open-uri'
require 'rest-client'
require 'net/http'
require 'uri'
require 'typhoeus'

class Bodega < ActiveRecord::Base


def self.encrypt(texto)
	key = texto

	#if Rails.env.production?
		data = 'ZC$&k:.gFIZ&pyp'   #PENDIENTE esto cambia segun dev o prod o no ?
		OpenSSL::HMAC.digest('SHA1',data,key)
		Base64.strict_encode64 OpenSSL::HMAC.digest('SHA1',data,key)
	#else
	#	data = 'WqhY79mm3N4ph6'   #PENDIENTE esto cambia segun dev o prod o no ?
	#	OpenSSL::HMAC.digest('SHA1',data,key)
	#	Base64.strict_encode64 OpenSSL::HMAC.digest('SHA1',data,key)
	#end
end

def self.crear_string(data)
	string_hash = "INTEGRACION grupo9:"
	header_agregar = string_hash+encrypt(data)
end	
	
def self.getAlmacenes () #entrega informacion sobre los almacenes de la bodega solicitada
	header = crear_string("GET")
	
	#if Rails.env.production?
		buffer = open('http://integracion-2016-prod.herokuapp.com/bodega/almacenes', "Content-Type"=>"application/json", "Authorization" => header).read
	#else
	#	buffer = open('http://integracion-2016-dev.herokuapp.com/bodega/almacenes', "Content-Type"=>"application/json", "Authorization" => header).read
	#end

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
	
	#if Rails.env.production?
		buffer = open('http://integracion-2016-prod.herokuapp.com/bodega/skusWithStock?almacenId='+almacenId , "Content-Type"=>"application/json", "Authorization" => header).read
	#else
	#	buffer = open('http://integracion-2016-dev.herokuapp.com/bodega/skusWithStock?almacenId='+almacenId , "Content-Type"=>"application/json", "Authorization" => header).read
	#end

	resultado = JSON.parse(buffer)

end

def self.getStock(almacenId, sku) #devuelve todos los productos de un sku que estan en un almacen
	header = crear_string("GET"+almacenId.to_s+sku.to_s)
	
	#if Rails.env.production?
		buffer = open('http://integracion-2016-prod.herokuapp.com/bodega/stock?almacenId='+almacenId.to_s+"&sku="+sku.to_s, "Content-Type"=>"application/json", "Authorization" => header).read
	#else
	#	buffer = open('http://integracion-2016-dev.herokuapp.com/bodega/stock?almacenId='+almacenId+"&sku="+sku, "Content-Type"=>"application/json", "Authorization" => header).read
	#end

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
	
	#if Rails.env.production?
		response = RestClient.post 'http://integracion-2016-prod.herokuapp.com/bodega/moveStock', {:productoId => productoid, :almacenId => almacenid}.to_json, :Authorization => autorizacion, :content_type=> 'application/json'
	#else
	#	response = RestClient.post 'http://integracion-2016-dev.herokuapp.com/bodega/moveStock', {:productoId => productoid, :almacenId => almacenid}.to_json, :Authorization => autorizacion, :content_type=> 'application/json'
	#end

	resultado = JSON.parse(response)
end

def self.moveStockBodega(productoid,almacenid, oc, precio) #Almacén de recepción de la bodega del grupo de destino
	autorizacion =crear_string("POST"+productoid+almacenid)
	
	#if Rails.env.production?
		response = RestClient.post 'http://integracion-2016-prod.herokuapp.com/bodega/moveStockBodega', {:productoId => productoid, :almacenId => almacenid, :oc => oc, :precio => precio}.to_json, :Authorization => autorizacion, :content_type=> 'application/json'
	#else
	#	response = RestClient.post 'http://integracion-2016-dev.herokuapp.com/bodega/moveStockBodega', {:productoId => productoid, :almacenId => almacenid, :oc => oc, :precio => precio}.to_json, :Authorization => autorizacion, :content_type=> 'application/json'
	#end 

	resultado = JSON.parse(response)
end

def self.despacharStock(productoId, direccion, precio, oc)
	header = crear_string("DELETE"+productoId.to_s+direccion.to_s+precio.to_s+oc.to_s)
	#respuesta = RestClient.delete , {:productoId => productoId.to_s, :direccion => direccion.to_s, :precio => precio.to_i, :oc => oc.to_s}.to_json, :Authorization => header, :content_type=> 'application/x-www-form-urlencoded'
	puts header
	
	#if Rails.env.production?
		respuesta = Typhoeus::Request.new('http://integracion-2016-prod.herokuapp.com/bodega/stock', 
		method: :delete, 
		body: {productoId: productoId.to_s, direccion:  direccion.to_s, precio: precio.to_i, oc: oc.to_s}, 
		headers: {'Content-Type' => "application/x-www-form-urlencoded",'Authorization' => header})
	#else
	#	respuesta = Typhoeus::Request.new('http://integracion-2016-dev.herokuapp.com/bodega/stock', 
	#	method: :delete, 
	#	body: {productoId: productoId.to_s, direccion:  direccion.to_s, precio: precio.to_i, oc: oc.to_s}, 
	#	headers: {'Content-Type' => "application/x-www-form-urlencoded",'Authorization' => header})
	#end

	  return respuesta
end
#{
#   "productoId": "571262b7a980ba030058a83a",
#   "direccion": "a",
#   "precio": 2,
#   "oc": "572bf917acbda70300e27357"
#} oc 572e6eb218b3850300a6fcc5 product id = 572d367ab147af0300d2a8ed

def self.despacharPedido(idoc, sku, qty, precio)
	almacenes = getAlmacenes()
	totalDespachados = 0
	despacho = idAlmacenDespacho
	almacenes.each do |almacen|
		if almacen['despacho'] == true
			for i in 0..((qty/200.0).ceil)
				todos_los_productos = getStock(almacen['_id'],sku)
				todos_los_productos.each do |producto|
					if(totalDespachados<qty.to_i)
						resultado_de_delete = despacharStock(producto['_id'],"a", precio, idoc).run
						respuesta = JSON.parse(resultado_de_delete.response_body)
						
						if  respuesta['despachado']#poner el resultado del delete, la variable del bool
							puts "despachando"
							totalDespachados+=1
						end
					end
				end
			end
		end
	end
	puts "pedido despachado"	
end
 
def self.despacharPedidoB2c(sku, qty, direccion, precio, id_boleta)
	almacenes = getAlmacenes()
	totalDespachados = 0
	despacho = idAlmacenDespacho
	almacenes.each do |almacen|
		if almacen['despacho'] == true
			# aca tengo que hacer el for porque retorna 200 como maximo.
			#if qty>200 repetir
			for i in 0..((qty/200.0).ceil) #esto es porque el getStock te devuelve solo de a 200 unidades.
				todos_los_productos = getStock(almacen['_id'],sku)
				todos_los_productos.each do |producto|
					if(totalDespachados<qty.to_i)
						resultado_de_delete = despacharStock(producto['_id'],direccion, precio, id_boleta).run
						respuesta = JSON.parse(resultado_de_delete.response_body)
						
						if  respuesta['despachado']#poner el resultado del delete, la variable del bool
							puts "despachando"
							totalDespachados+=1
						end
					end
				end
			end
		end
	end
	puts "pedido despachado"
	

end
def self.despacharB2b(idoc, sku, qty, precio,almacenid)
almacenes = getAlmacenes()
totalDespachados = 0

almacenes.each do |almacen|
	if almacen['despacho'] == true
		todos_los_productos = getStock(almacen['_id'],sku)
		todos_los_productos.each do |producto|
			if(totalDespachados<qty.to_i)
					moveStockBodega(producto['_id'],almacenid.to_s, idoc,precio)	
					totalDespachados+=1
				
			end
		end
	end
end	
	

end

def self.producirStock(sKu, trxid, cAntidad) 
	stringSku = sKu.to_s
	stringCantidad = cAntidad.to_s
	autorizacion =crear_string("PUT"+stringSku+stringCantidad+trxid)
	
	#if Rails.env.production?
		response = RestClient.put 'http://integracion-2016-prod.herokuapp.com/bodega/fabrica/fabricar', {:sku => sKu, :trxId => trxid, :cantidad => cAntidad}.to_json, :Authorization => autorizacion, :content_type=> 'application/json'
	#else
	#	response = RestClient.put 'http://integracion-2016-dev.herokuapp.com/bodega/fabrica/fabricar', {:sku => sKu, :trxId => trxid, :cantidad => cAntidad}.to_json, :Authorization => autorizacion, :content_type=> 'application/json'		
	#end

	resultado = JSON.parse(response)
end

def self.getCuentaFabrica () #entrega la cuenta id de la fabrica 
	header = crear_string("GET")
	
	#if Rails.env.production?
		buffer = open('http://integracion-2016-prod.herokuapp.com/bodega/fabrica/getCuenta', "Content-Type"=>"application/json", "Authorization" => header).read
	#else
	#	buffer = open('http://integracion-2016-dev.herokuapp.com/bodega/fabrica/getCuenta', "Content-Type"=>"application/json", "Authorization" => header).read		
	#end

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
def self.producirChocolate()
	moverInsumo(20,296)
	moverInsumo(25,269)
	moverInsumo(7,251)
	cantidad = 800
	precioChoco = 2372*cantidad
	sku = 46
	trx = pagarFabricacion(precioChoco)
	producirStock(sku, trx, cantidad)
end
def self.producirPasta()
	moverInsumo(19,160)
	moverInsumo(26,172)
	moverInsumo(2,155)
	loTes = lotes.to_i
	cantidad = 500
	precioPasta = 1652*cantidad
	sku = 46
	trx = pagarFabricacion(precioPasta)
	producirStock(sku, trx, cantidad)
end
def self.producirHamb()
	moverInsumo(1,935)
	moverInsumo(26,65)
	
	loTes = lotes.to_i
	cantidad = 620
	precioHamb = 2271*cantidad
	sku = 46
	trx = pagarFabricacion(precioHamb)
	producirStock(sku, trx, cantidad)
end
def self.pagarFabricacion(precio)
	jsonCuenta = getCuentaFabrica()
	idCuentaF = jsonCuenta['cuentaId']
	
	#if Rails.env.production?
		response = Banco.transferir(precio,"572aac69bdb6d403005fb057",idCuentaF)  
	#else 
	#	response = Banco.transferir(precio,"571262c3a980ba030058ab66",idCuentaF)  
	#end

	response["_id"]
	
end

def self.logicaCacaos()
	cacao = getStockProducto("20")
	if cacao.to_i <= 4000
	lotes1 = 4500 - cacao.to_i
	
	lotes = lotes1/60 
	
	abastecerCacao(lotes)
	end
	
end
def self.logicaAbastecerChocolate()
	chocolate = getStockProducto("46")
	if chocolate.to_i <= 4000
	response = revisarMaterialesChocolate("1")
		if response['azucar']== false 
		B2b.comprarStock("25","269")
		
		end
		if response['leche'] == false 	
		B2b.comprarStock("7","251")
		
		end
	end
end
def self.logicaHacerChocolate()
	response = revisarMaterialesChocolate("1")
	if(response['azucar']&&response['leche']&&response['cacao'])
	producirChocolate()
	end
end
def self.logicaAbastecerPasta()
	chocolate = getStockProducto("48")
	if chocolate.to_i <= 4000
	response = revisarMaterialesPasta("1")
		if response['semola']== false 
		B2b.comprarStock("19","160")	
		end
		if response['sal'] == false 	
		B2b.comprarStock("26","172")	
		end
		if response['huevo'] == false 	
		B2b.comprarStock("2","155")
		end
		
		
	end
end
def self.logicaHacerPasta()
	response = revisarMaterialesPasta("1")
	if(response['semola']&&response['sal']&&response['huevo'])
	producirPasta()
	end
end
def self.logicaAbastecerHamb()
	chocolate = getStockProducto("56")
	if chocolate.to_i <= 4000
	response = revisarMaterialesHamb("1")
		if response['pollo']== false 
		B2b.comprarStock("1","935")	
		end
		if response['sal'] == false 	
		B2b.comprarStock("26","65")	
		end
		
	end
end
def self.logicaHacerHamb()
	response = revisarMaterialesHamb("1")
	if(response['pollo']&&response['sal'])
	producirPasta()
	end
end

def self.vaciarRecepcion()

	#if Rails.env.production?
    	recepcion = "572aad41bdb6d403005fb4b8"
    	general1 = "572aad41bdb6d403005fb4ba"
    	general2 = "572aad41bdb6d403005fb540"
    	pulmon = "572aad41bdb6d403005fb541"   
    
    #else
    #	recepcion = "571262aaa980ba030058a3b0"    
    #	general1 = "571262aaa980ba030058a3b2"     
    #	general2 = "571262aaa980ba030058a40a"     
    #	pulmon = "571262aaa980ba030058a40b"       
    #end 
    	
    productosRecepcion = getSkusWithStock(recepcion)
    p "1"
    if (productosRecepcion.size > 0)
        productosRecepcion.each do |tipoProducto|
            p "2"
            #cantidadProducto = tipoProducto['total'] 
              skuProducto = tipoProducto['_id']
              productoSKU = getStock(recepcion, skuProducto)
              p "3"
              productoSKU.each do |productito|
                  p "4"
                  productoMovido = false
                  almacenes = getAlmacenes
                  almacenes.each do |almacen|
                      p "5"
                      if ((almacen['_id'] = general1) and (almacen['totalSpace'] > almacen['usedSpace'])and (!productoMovido))
                              moveStock(productito['_id'],general1)
                              productoMovido = true
                              p "6"
                              #vaciarRecepcion()
                      elsif ((almacen['_id'] = general2) and (almacen['totalSpace'] > almacen['usedSpace'])and (!productoMovido))
                              moveStock(productito['_id'],general2)
                              productoMovido = true
                              #vaciarRecepcion()
                      elsif ((almacen['_id'] = pulmon) and (almacen['totalSpace'] > almacen['usedSpace'])and (!productoMovido))
                          moveStock(productito['_id'],pulmon)
                          productoMovido = true
                          #vaciarRecepcion()
                      end
                      
                  end    
              end    
        end
    end
  end

def self.vaciarPulmon()

    #if Rails.env.production?
    	recepcion = "572aad41bdb6d403005fb4b8"
    	general1 = "572aad41bdb6d403005fb4ba"
    	general2 = "572aad41bdb6d403005fb540"
    	pulmon = "572aad41bdb6d403005fb541"   
    #else
    #	recepcion = "571262aaa980ba030058a3b0"    
    #	general1 = "571262aaa980ba030058a3b2"     
    #	general2 = "571262aaa980ba030058a40a"     
    #	pulmon = "571262aaa980ba030058a40b"       
   	#end

    productosRecepcion = getSkusWithStock(pulmon)
    p "1"
    if (productosRecepcion.size > 0)
        productosRecepcion.each do |tipoProducto|
            p "2"
            #cantidadProducto = tipoProducto['total'] 
              skuProducto = tipoProducto['_id']
              productoSKU = getStock(pulmon, skuProducto)
              p "3"
              productoSKU.each do |productito|	
                  p "4"
                  #productoMovido = false
                  #almacenes = getAlmacenes
                  #almacenes.each do |almacen|
                      #p "5"
                      #if ((almacen['_id'] = general1) and (almacen['totalSpace'] > almacen['usedSpace'])and (!productoMovido))
                  moveStock(productito['_id'],general1)
                              #productoMovido = true
                              #p "6"	
                              #vaciarRecepcion()
                      #elsif ((almacen['_id'] = general2) and (almacen['totalSpace'] > almacen['usedSpace'])and (!productoMovido))
                              #moveStock(productito['_id'],general2)
                              #productoMovido = true
                              #vaciarRecepcion()
                      #end
                      
                  #end    
              end    
        end
    end
  end
end
