require 'bunny'
require 'rubygems'

class Promo < ActiveRecord::Base

  validates :sku, :precio, :inicio, :fin, :codigo, presence: true




def self.leer_cola
	b = Bunny.new 'amqp://ioxyydey:ARS_RdIo2M2cntXkecPQcSCTLvMwiwxV@hyena.rmq.cloudamqp.com/ioxyydey'
	b.start

	# open a channel
	ch = b.create_channel

  # declare a queue
	q = ch.queue('ofertas',:auto_delete => true, :exclusive => false, :durable => false) 

  # get message from the queue 
  promo = q.pop
  promocion=promo[2].to_s
  prom=JSON.parse(promocion)

  sku= prom['sku']
  precio=prom['precio']
  inicio=prom['inicio']
  fin=prom['fin']
  codigo=prom['codigo']
  publicar=prom['publicar']
  if publicar
    Promo.create(sku: sku, precio: precio, inicio: inicio, fin: fin, codigo: codigo)
    publish(sku,precio,inicio,fin,codigo,publicar)
  end
  # close the connection
	ch.close
  b.stop
end

def self.cronjob
	leer_cola
	return nil if promos.empty?

  promos.each do |h|
	 sku, precio, inicio, fin, codigo, publicar = h["sku"], h["precio"], Time.at(h["inicio"].to_i / 1000), Time.at(h["fin"].to_i / 1000), h["codigo"], h["publicar"]
	  # publicar_facebook(sku, precio, inicio, fin, codigo, publicar) if publicar
	  # publicar_twitter(sku, precio, inicio, fin, codigo, publicar) if publicar
    
  end 
end



end
