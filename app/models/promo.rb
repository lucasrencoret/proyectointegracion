require 'bunny'
require 'rubygems'

class Promo < ActiveRecord::Base

def self.leer_cola
	#b =Bunny.new('amqp://ioxyydey:ARS_RdIo2M2cntXkecPQcSCTLvMwiwxV@hyena.rmq.cloudamqp.com/ioxyydey')
	b = Bunny.new 'amqp://ioxyydey:ARS_RdIo2M2cntXkecPQcSCTLvMwiwxV@hyena.rmq.cloudamqp.com/ioxyydey'
	b.start

	# open a channel
	ch = b.create_channel


	q = ch.queue("codigos") # declare a queue

	# declare default direct exchange which is bound to all queues
	# e = b.exchange("")

	# publish a message to the exchange which then gets routed to the queue
=begin
	q.publish('{
	"sku" : "string",
	"precio" : "int",
	"inicio" : "fecha",
	"fin" : "fecha",
	"codigo": "string",
	"publicar": true
}')#, :key => 'test1')
=end

	delivery_info, metadata, payload = q.pop # get message from the queue

	#puts "This is the message: #{payload}"
	b.stop # close the connection
	return nil unless payload
	JSON.parse(payload)
end

end
