require 'rubygems'
require 'open-uri'

class B2b < ActiveRecord::Base

# la llave es el SKU, y los valores: grupo, costo unitario, lote, idgrupo 

@@productosProduccion = Hash["19" => [1,1428, 1420,"572aac69bdb6d403005fb042"],
				 "27" => [1,1084,620,"572aac69bdb6d403005fb042"],	
				 "45" => [1,1500,800,"572aac69bdb6d403005fb042"],
				 "2"  => [2,513,150,"572aac69bdb6d403005fb043"],
				 "21" => [2,1272,100,"572aac69bdb6d403005fb043"],
				 "32" => [2,996,230,"572aac69bdb6d403005fb043"],
				 "8"  => [3,1313,100,"572aac69bdb6d403005fb044"],
				 "14" => [3,696,1750,"572aac69bdb6d403005fb044"],
				 "31" => [3,1434,960,"572aac69bdb6d403005fb044"],
				 "38" => [4,1201,30,"572aac69bdb6d403005fb045"],
				 "44" => [4,1091,50,"572aac69bdb6d403005fb045"],
				 "33" => [5,834,90,"572aac69bdb6d403005fb046"],
				 "52" => [5,1466,890,"572aac69bdb6d403005fb046"],
				 "13" => [6,1286,1000,"572aac69bdb6d403005fb047"],
				 "25" => [6,782,560,"572aac69bdb6d403005fb047"],
				 "1"  => [7,892,300,"572aac69bdb6d403005fb048"],
				 "39" => [7,889,250,"572aac69bdb6d403005fb048"],
				 "26" => [8,753,144,"572aac69bdb6d403005fb049"],
				 "37" => [8,764,1200,"572aac69bdb6d403005fb049"],
				 "20" => [9,1280,60,"572aac69bdb6d403005fb04a"],
				 "3"  => [10,1468,30,"572aac69bdb6d403005fb04b"],
				 "9"  => [10,1397,620,"572aac69bdb6d403005fb04b"],
				 "43" => [11,1197,1000,"572aac69bdb6d403005fb04c"],
				 "7"  => [12,941,1000,"572aac69bdb6d403005fb04d"],
                 "15" => [12,969,480,"572aac69bdb6d403005fb04d"] ]

def self.productosProduccion()
	@@productosProduccion
end

# la llave es el SKU, y los valores: grupo, costo unitario, lote, idgrupo 

@@productosDesarrollo = Hash["19" => [1,1428, 1420,"571262b8a980ba030058ab4f"],
				 "27" => [1,1084,620,"571262b8a980ba030058ab4f"],	
				 "45" => [1,1500,800,"571262b8a980ba030058ab4f"],
				 "2"  => [2,513,150,"571262b8a980ba030058ab50"],
				 "21" => [2,1272,100,"571262b8a980ba030058ab50"],
				 "32" => [2,996,230,"571262b8a980ba030058ab50"],
				 "8"  => [3,1313,100,"571262b8a980ba030058ab51"],
				 "14" => [3,696,1750,"571262b8a980ba030058ab51"],
				 "31" => [3,1434,960,"571262b8a980ba030058ab51"],
				 "38" => [4,1201,30,"571262b8a980ba030058ab52"],
				 "44" => [4,1091,50,"571262b8a980ba030058ab52"],
				 "33" => [5,834,90,"571262b8a980ba030058ab53"],
				 "52" => [5,1466,890,"571262b8a980ba030058ab53"],
				 "13" => [6,1286,1000,"571262b8a980ba030058ab54"],
				 "25" => [6,782,560,"571262b8a980ba030058ab54"],
				 "1"  => [7,892,300,"571262b8a980ba030058ab55"],
				 "39" => [7,889,250,"571262b8a980ba030058ab55"],
				 "26" => [8,753,144,"571262b8a980ba030058ab56"],
				 "37" => [8,764,1200,"571262b8a980ba030058ab56"],
				 "20" => [9,1280,60,"571262b8a980ba030058ab57"],
				 "3"  => [10,1468,30,"571262b8a980ba030058ab58"],
				 "9"  => [10,1397,620,"571262b8a980ba030058ab58"],
				 "43" => [11,1197,1000,"571262b8a980ba030058ab59"],
				 "7"  => [12,941,1000,"571262b8a980ba030058ab5a"],
                 "15" => [12,969,480,"571262b8a980ba030058ab5a"] ]

def self.productosDesarrollo()
	@@productosDesarrollo
end


def self.comprarStock(sku, cantidad)

  	#if Rails.env.production?
    	numGrupo = productosProduccion.fetch(sku)[0]
    	idgrupo_proveedor = productosProduccion.fetch(sku)[3]
    	precioUnitario = productosProduccion.fetch(sku)[1]

    #else
   # 	numGrupo = productosDesarrollo.fetch(sku)[0]
   # 	idgrupo_proveedor = productosDesarrollo.fetch(sku)[3]
   # 	precioUnitario = productosDesarrollo.fetch(sku)[1]
   # end

	buffer = open('http://integra'+numGrupo.to_s+'.ing.puc.cl/api/consultar/'+ sku.to_s , "Content-Type"=>"application/json").read
	resultado = JSON.parse(buffer)
	
	if resultado['stock'].to_i >= cantidad.to_i
		
		#if Rails.env.production?
			orden = Oc.crearOc("b2b", cantidad.to_i, sku, idgrupo_proveedor, precioUnitario, "lll", "572aac69bdb6d403005fb04a", 1470495430000)

		#else 
		#	orden = Oc.crearOc("b2b", cantidad.to_i, sku, idgrupo_proveedor, precioUnitario, "lll", "571262b8a980ba030058ab57", 1470495430000)
		#end

		idoc = orden['_id']
		
		

		buffer = open('http://integra'+numGrupo.to_s+'.ing.puc.cl/api/oc/recibir/'+ idoc.to_s , "Content-Type"=>"application/json").read
		resultado1 = JSON.parse(buffer)
		
		if !resultado1['aceptado']
		#anularOc
		end
			
	end


end

# la llave es el id del grupo, 1er numero del grupo, 2do banco, 3er almacen de recepcion 
@@gruposProduccion = Hash["572aac69bdb6d403005fb042" => [1,"572aac69bdb6d403005fb04e","572aad41bdb6d403005fb066"],
				 "572aac69bdb6d403005fb043" => [2,"572aac69bdb6d403005fb04f","572aad41bdb6d403005fb0ba"],
				 "572aac69bdb6d403005fb044" => [3,"572aac69bdb6d403005fb050","572aad41bdb6d403005fb1bf"],
				 "572aac69bdb6d403005fb045" => [4,"572aac69bdb6d403005fb051","572aad41bdb6d403005fb208"],
				 "572aac69bdb6d403005fb046" => [5,"572aac69bdb6d403005fb052","572aad41bdb6d403005fb278"],
				 "572aac69bdb6d403005fb047" => [6,"572aac69bdb6d403005fb053","572aad41bdb6d403005fb2d8"],
				 "572aac69bdb6d403005fb048" => [7,"572aac69bdb6d403005fb054","572aad41bdb6d403005fb3b9"],
				 "572aac69bdb6d403005fb049" => [8,"572aac69bdb6d403005fb056","572aad41bdb6d403005fb416"],
				 "572aac69bdb6d403005fb04a" => [9,"572aac69bdb6d403005fb057","572aad41bdb6d403005fb4b8"],
				 "572aac69bdb6d403005fb04b" => [10,"572aac69bdb6d403005fb058","572aad41bdb6d403005fb542"],
				 "572aac69bdb6d403005fb04c" => [11,"572aac69bdb6d403005fb059","572aad41bdb6d403005fb5b9"],
				 "572aac69bdb6d403005fb04d" => [12,"572aac69bdb6d403005fb05a","572aad42bdb6d403005fb69f"]]

def self.gruposProduccion()
	@@gruposProduccion
end

# la llave es el id del grupo, 1er numero del grupo, 2do banco, 3er almacen de recepcion 
@@gruposDesarrollo = Hash["571262b8a980ba030058ab4f" => [1,"571262c3a980ba030058ab5b","571262aaa980ba030058a147"],
				 "571262b8a980ba030058ab50" => [2,"571262c3a980ba030058ab5c","571262aaa980ba030058a14e"],
				 "571262b8a980ba030058ab51" => [3,"571262c3a980ba030058ab5d","571262aaa980ba030058a1f1"],
				 "571262b8a980ba030058ab52" => [4,"571262c3a980ba030058ab5f","571262aaa980ba030058a240"],
				 "571262b8a980ba030058ab53" => [5,"571262c3a980ba030058ab61","571262aaa980ba030058a244"],
				 "571262b8a980ba030058ab54" => [6,"571262c3a980ba030058ab62","572aad41bdb6d403005fb2d8"],    #grupo 6 sin almacen de desarrollo publicado
				 "571262b8a980ba030058ab55" => [7,"571262c3a980ba030058ab60","572aad41bdb6d403005fb3b9"],    #grupo 6 sin almacen de desarrollo publicado
				 "571262b8a980ba030058ab56" => [8,"571262c3a980ba030058ab5e","571262aaa980ba030058a31e"],
				 "571262b8a980ba030058ab57" => [9,"571262c3a980ba030058ab66","571262aaa980ba030058a3b0"],
				 "571262b8a980ba030058ab58" => [10,"571262c3a980ba030058ab63","571262aaa980ba030058a40c"],
				 "571262b8a980ba030058ab59" => [11,"571262c3a980ba030058ab64","571262aaa980ba030058a488"],
				 "571262b8a980ba030058ab5a" => [12,"571262c3a980ba030058ab65","571262aba980ba030058a5c6"]]

def self.gruposDesarrollo()
	@@gruposDesarrollo
end

def self.obtenerGrupo(grupoID)
	#if Rails.env.production?
		numGrupo = gruposProduccion.fetch(grupoID)[0]

	#else
	#	numGrupo = gruposDesarrollo.fetch(grupoID)[0]
	#end

end

def self.obtenerBanco(grupoID)
	#if Rails.env.production?
		numGrupo = gruposProduccion.fetch(grupoID)[1]

	#else
	#	numGrupo = gruposDesarrollo.fetch(grupoID)[1]
	#end

end

def self.obtenerRecepcion(grupoID)
	#if Rails.env.production?
		numGrupo = gruposProduccion.fetch(grupoID)[2]

	#else
	#	numGrupo = gruposDesarrollo.fetch(grupoID)[2]
	#end

end



end
