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
	q = ch.queue("codigos") 

  # get message from the queue 
  promos = []

	delivery_info, metadata, payload = q.pop

  while payload != nil
    promos << JSON.parse(payload)
    delivery_info, metadata, payload = q.pop
  end

  # close the connection
	b.stop
  promos
end

def self.cronjob
	promos = leer_cola
	return nil if promos.empty?

  promos.each do |h|
	 sku, precio, inicio, fin, codigo, publicar = h["sku"], h["precio"], Time.at(h["inicio"].to_i / 1000), Time.at(h["fin"].to_i / 1000), h["codigo"], h["publicar"]
	  # publicar_facebook(sku, precio, inicio, fin, codigo, publicar) if publicar
	  # publicar_twitter(sku, precio, inicio, fin, codigo, publicar) if publicar
    Promo.create!(sku: sku, precio: precio, inicio: inicio, fin: fin, codigo: codigo)
  end 
end

def self.test_publicar
  b = Bunny.new 'amqp://ioxyydey:ARS_RdIo2M2cntXkecPQcSCTLvMwiwxV@hyena.rmq.cloudamqp.com/ioxyydey'
  b.start

  # open a channel
  ch = b.create_channel

  # declare a queue
  q = ch.queue("codigos") 

  # publish a message to the exchange which then gets routed to the queue
  3.times do
    q.publish('{
    "sku" : "32987124",
    "precio" : 1999,
    "inicio" : "1700000000000",
    "fin" : "1710000000000",
    "codigo": "mi_codigo",
    "publicar": true
    }')
  end
  b.stop

end

end
