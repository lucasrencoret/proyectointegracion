require 'open-uri'
require 'rubygems'
class Oc < ActiveRecord::Base
def self.getOc(id)
    buffer = open('http://mare.ing.puc.cl/oc/obtener/'+id , "Content-Type"=>"application/json").read
    resultado = JSON.parse(buffer)
    
end
end
