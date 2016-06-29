class TwitterController < ApplicationController
  def index
  end

  def publish
  	sku='20'
    precio=1
    inicio=1
    fin=1
    codigo=1
    publicar=true
    
  	
  	if sku.to_s=='20'	
  		client = Twitter::REST::Client.new do |config|
  		config.consumer_key        = "LRXI8ilvCl0Hss49OcUvhzjgS"
  		config.consumer_secret     = "Ve6NTOjYFqpgPOOwAXAqkIhzqd64Ss8rm7nJSlekhiR3LQLHkF"
  		config.access_token        = "747885503983280128-aQUz1SOHqGvvsSBH3jqPXOtYsd9AkHV"
  		config.access_token_secret = "XleArA7mRLB1HuQHmmN5XAYndNzke7E9fYqQeBEnsdypi"
		end

	texto= "Utiliza el codigo #{codigo} para tener un descuento en el producto #{sku} a tan solo #{precio}. Valido desde #{inicio} hasta #{fin}"
	client.update_with_media(texto, open("http://e03-elmundo.uecdn.es/assets/multimedia/imagenes/2015/11/13/14474300157302.jpg"))
  	
  	

  	@graph = Koala::Facebook::API.new("EAAOZBw81vhr8BAM7yls7zf8gPf72tQ2hohEurOrvaC1ZCRCfVa5zupPvFjIiOzR66sj3mJm1532AZBjrd3mK73")
 	@graph.put_wall_post(texto,{link:"http://e03-elmundo.uecdn.es/assets/multimedia/imagenes/2015/11/13/14474300157302.jpg"})


	end
end
end
