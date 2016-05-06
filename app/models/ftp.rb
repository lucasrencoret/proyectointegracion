require 'net/ftp' 
require 'net/ssh'
require 'net/sftp'
class Ftp < ActiveRecord::Base
@@tiempo_inicio = Time.new(2015, 5, 5, 6, 0, 0, "+03:00")

def self.tiempo_inicio
      @@tiempo_inicio
end
def self.ultimo_tiempo()
      @@tiempo_inicio
end
def self.conecta()
    host = 'mare.ing.puc.cl'
    port = '22'
    user = 'integra9'
    password = 'cdFybj2t'
    
    
    #upload a file or directory to the remote host
    #Rails.logger.info("Creating SFTP connection")
    #session=Net::SSH.start(host,user, :password=>password,:port=>port)
    #sftp=Net::SFTP::Session.new(session).connect!
    
    Net::SFTP.start(host,user, :password=>password) do |sftp|
    
    sftp.dir.foreach("/pedidos") do |entry|
            #puts entry.longname
            if entry.file?()
                #sftp.download!("/pedidos/"+entry.name, "/Users/lucasrencoret/Desktop/test/"+entry.name)
                #puts "lo baje!"
                nombre_split = entry.longname.split
                nombre = nombre_split[8]
                mes = nombre_split[5]
                dia = nombre_split[6]
                horas = nombre_split[7].split(":")
                hora = horas[0]
                minuto = horas[1]
                
                tiempo = Time.new('2016', mes, dia, hora, minuto, '0', "+00:00")
                #Time.new(2002, 10, 31, 2, 2, 2, "+00:00")
                if tiempo > tiempo_inicio
                  @@tiempo_inicio = tiempo
                  #bajar la info
                  data = sftp.download!("/pedidos/"+entry.name)
                  #puts data
                  doc = Nokogiri::XML(data)
                  thing = doc.at_xpath('order')
                  orden_id = thing.at_xpath('//id').content
                  orden_sku = thing.at_xpath('//sku').content
                  orden_qty = thing.at_xpath('//qty').content
                
                  #bodegas = Bodega.connection
                  respuesta = Bodega.consultar(orden_sku)
                  seguir = false
                  if respuesta['stock'].to_i > orden_qty.to_i
                        #mandar a hacer
                        orden_de_compra = Oc.getOc(orden_id)
                        
                        if orden_sku == "20"
                              if orden_de_compra['precioUnitario']> 1612 #precio sku 20
                                    seguir = true
                                    orden_precio = orden_de_compra['precioUnitario']
                              end
                              
                        end
                        if orden_sku == "46"
                              if orden_de_compra['precioUnitario']> 8514 #precio sku 46
                                    seguir = true
                                    orden_precio = orden_de_compra['precioUnitario']
                              end
                        end
                        if orden_sku == "48"
                              if orden_de_compra['precioUnitario']> 6627 #precio sku 48
                                    seguir = true
                                    orden_precio = orden_de_compra['precioUnitario']
                              end
                              
                        end
                        if orden_sku == "56"
                              if orden_de_compra['precioUnitario']> 5052 #precio sku 56
                                    seguir = true
                                    orden_precio = orden_de_compra['precioUnitario']
                              end
                        end
                        
                        
                        if seguir
                              Oc.recepcionarOc(orden_id)
                              Bodega.moverInsumo(orden_sku, orden_qty)
                              Bodega.emitirFactura(orden_id)
                              Bodega.despacharPedido(orden_id, orden_sku, orden_qty, orden_precio)
                              puts "aceptar orden"
                              
                        else
                              #Oc.rechazarOc(orden_id, "Esta por debajo del Precio")
                              puts "rechazar Oc por precio"
                        end
                        
                  else
                        #Oc.rechazarOc(orden_id, "No tenemos stock")
                        puts "rechazar Oc por stock" + orden_sku.to_s + " el stock" + orden_qty.to_s
                  end
                end
                
                
                
                
                #break
            end
    end

        
    end

end


end
