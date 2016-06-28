class LogisticaController < ApplicationController

def index
    @ocs = Oc.all

    @respuesta = Banco.obtenerCuenta('571262c3a980ba030058ab66')
    @b2cs = B2c.all
    
end

end
