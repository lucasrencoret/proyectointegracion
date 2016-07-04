class TwitterController < ApplicationController
  def index
  end

  def publish (sku, precio, inicio, fin, codigo, publicar)

if sku=='20'
  client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "LRXI8ilvCl0Hss49OcUvhzjgS"
  config.consumer_secret     = "Ve6NTOjYFqpgPOOwAXAqkIhzqd64Ss8rm7nJSlekhiR3LQLHkF"
  config.access_token        = "747885503983280128-aQUz1SOHqGvvsSBH3jqPXOtYsd9AkHV"
  config.access_token_secret = "XleArA7mRLB1HuQHmmN5XAYndNzke7E9fYqQeBEnsdypi"
end

	client.update_with_media("text", open("http://www.chocozona.com/files/image/0/666/4f16ee2ed5421.jpg"))
  end

  @graph = Koala::Facebook::API.new("EAAOZBw81vhr8BALLLv09Vck2t5DqX92YZC3RFjbewiV4WwHly1PUPZA8ENV1IyIdUWAsmww4MEwFU1r7lPxpHno28TRylBDSFYRZBZCMeMWjUAnfFSJ236MxcuUluIaNgPXR1Cs3hh72LzmnXoViV2XLHFQxqxkTtleccWXJTnAZDZD")
  @graph.put_wall_post("text",{link:"http://www.chocozona.com/files/image/0/666/4f16ee2ed5421.jpg"})

end
end 