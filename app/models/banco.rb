require 'open-uri'
require 'rubygems'

class Banco < ActiveRecord::Base
def self.obtenerCuenta(cuentaId)
	buffer = open('http://mare.ing.puc.cl/banco/cuenta/'+cuentaId , "Content-Type"=>"application/json").read
	resultado = JSON.parse(buffer)

end
end
