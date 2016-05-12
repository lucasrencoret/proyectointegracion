require 'rubygems'
require 'open-uri'

class B2b < ActiveRecord::Base

# la llave es el SKU, y los valores: grupo, costo unitario, lote, idgrupo 

@@productos = Hash["19" => [1,1428, 1420,"572aac69bdb6d403005fb042"],
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

def self.productos()
	@@productos
end


def self.comprarStock(sku, cantidad)

    numGrupo = productos.fetch(sku)[0]
    idgrupo_proveedor = productos.fetch(sku)[3]
    precioUnitario = productos.fetch(sku)[1]

	buffer = open('http://integra'+numGrupo.to_s+'.ing.puc.cl/api/consultar/'+ sku.to_s , "Content-Type"=>"application/json").read
	resultado = JSON.parse(buffer)
	
	if resultado['stock'].to_i >= cantidad.to_i
		
		orden = Oc.crearOc("b2b", cantidad.to_i, sku, idgrupo_proveedor, precioUnitario, "lll", "572aac69bdb6d403005fb04a", 1470495430000)
		idoc = orden['_id']
		
		

		buffer = open('http://integra'+numGrupo.to_s+'.ing.puc.cl/api/oc/recibir/'+ idoc.to_s , "Content-Type"=>"application/json").read
		resultado1 = JSON.parse(buffer)
		
		if !resultado1['aceptado']
		#anularOc
		end
			
	end


end

# la llave es el id del grupo, primer valor es el numero del grupo, segundo valor es cuenta de banco, tercer valor es almacen de recepcion 
@@grupos = Hash["572aac69bdb6d403005fb042" => [1,"572aac69bdb6d403005fb04e","572aad41bdb6d403005fb066"],
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

def self.grupos()
	@@grupos
end

def self.obtenerGrupo(grupoID)
	numGrupo = grupos.fetch(grupoID)[0]

end

def self.obtenerBanco(grupoID)
	numGrupo = grupos.fetch(grupoID)[1]

end

def self.obtenerRecepcion(grupoID)
	numGrupo = grupos.fetch(grupoID)[2]

end



end
