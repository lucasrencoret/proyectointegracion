require 'rubygems'
require 'base64'
require 'cgi'
require 'hmac-sha1'

class Bodega < ActiveRecord::Base

def encriptar(string texto)
    key = 'WqhY79mm3N4ph6'
    signature = texto
    hmac = HMAC::SHA1.new(key)
    hmac.update(signature)
    puts CGI.escape(Base64.encode64("#{hmac.digest}\n"))
    return hmac
end
def obtener_almacenes()


end
