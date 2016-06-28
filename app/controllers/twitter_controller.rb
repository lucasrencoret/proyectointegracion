class TwitterController < ApplicationController
  def index
  end

  def publish
  	client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "LRXI8ilvCl0Hss49OcUvhzjgS"
  config.consumer_secret     = "Ve6NTOjYFqpgPOOwAXAqkIhzqd64Ss8rm7nJSlekhiR3LQLHkF"
  config.access_token        = "747885503983280128-aQUz1SOHqGvvsSBH3jqPXOtYsd9AkHV"
  config.access_token_secret = "XleArA7mRLB1HuQHmmN5XAYndNzke7E9fYqQeBEnsdypi"
end

	client.update_with_media("text", open("http://e03-elmundo.uecdn.es/assets/multimedia/imagenes/2015/11/13/14474300157302.jpg"))
  end
end
