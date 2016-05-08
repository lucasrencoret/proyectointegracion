require 'rubygems'
require 'open-uri'

class B2b < ActiveRecord::Base

# la llave es el SKU, y los valores: grupo, costo unitario, lote, idgrupo 

@@productos = Hash["19" => [1,1428, 1420,"571262b8a980ba030058ab4f"],
				 "27" => [1,1084,620,"571262b8a980ba030058ab4f"],	
				 "45" => [1,1500,800,"571262b8a980ba030058ab4f"],
				 "2"  => [2,513,150,"571262b8a980ba030058ab4f"],
				 "21" => [2,1272,100,"571262b8a980ba030058ab4f"],
				 "32" => [2,996,230,"571262b8a980ba030058ab4f"],
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

def self.productos()
	@@productos
end


def self.comprarStock(sku, cantidad)

    numGrupo = productos.fetch(sku)[0]
    idgrupo_proveedor = productos.fetch(sku)[3]
    precioUnitario = productos.fetch(sku)[1]

    p "prueba"
   
	buffer = open('http://integra'+numGrupo.to_s+'.ing.puc.cl/api/consultar/'+ sku.to_s , "Content-Type"=>"application/json").read
	resultado = JSON.parse(buffer)
	p resultado
	if resultado['stock'].to_i >= cantidad.to_i
		#p "prueba 2"
		orden = Oc.crearOc("b2b", cantidad.to_i, sku, idgrupo_proveedor, precioUnitario, "lll", "571262b8a980ba030058ab57", 1470495430000)
		idoc = orden['_id']
		p idoc
		

		buffer = open('http://integra'+numGrupo.to_s+'.ing.puc.cl/api/oc/recibir/'+ idoc.to_s , "Content-Type"=>"application/json").read
		resultado1 = JSON.parse(buffer)
		p resultado1
		if !resultado1['aceptado']
		#anularOc
		end
			
	end


end

# la llave es el id del grupo, primer valor es el numero del grupo, segundo valor es cuenta de banco, tercer valor es almacen de recepcion 
@@grupos = Hash["571262b8a980ba030058ab4f" => [1,"571262c3a980ba030058ab5b","571262aaa980ba030058a147"],
				 "571262b8a980ba030058ab50" => [2,"571262c3a980ba030058ab5c","571262aaa980ba030058a14e"],
				 "571262b8a980ba030058ab51" => [3,"571262c3a980ba030058ab5d","571262aaa980ba030058a1f1"],
				 "571262b8a980ba030058ab52" => [4,"571262c3a980ba030058ab5f","571262aaa980ba030058a240"],
				 "571262b8a980ba030058ab53" => [5,"571262c3a980ba030058ab61","571262aaa980ba030058a244"],
				 "571262b8a980ba030058ab54" => [6,"571262c3a980ba030058ab62",""],
				 "571262b8a980ba030058ab55" => [7,"571262c3a980ba030058ab60",""],
				 "571262b8a980ba030058ab56" => [8,"571262c3a980ba030058ab5e","571262aaa980ba030058a31e"],
				 "571262b8a980ba030058ab57" => [9,"571262c3a980ba030058ab66","571262aaa980ba030058a3b0"],
				 "571262b8a980ba030058ab58" => [10,"571262c3a980ba030058ab63",""],
				 "571262b8a980ba030058ab59" => [11,"571262c3a980ba030058ab64","571262aaa980ba030058a488"],
				 "571262b8a980ba030058ab5a" => [12,"571262c3a980ba030058ab65","571262aba980ba030058a5c6"]]

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
