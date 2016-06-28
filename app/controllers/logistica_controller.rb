class LogisticaController < ApplicationController

def index
    @ocs = Oc.all

    @respuesta = Banco.obtenerCuenta('571262c3a980ba030058ab66')
    @b2cs = B2c.all
    @almacenes = Bodega.getAlmacenes()
    general1 = false
    @almacenes.each do |almacen|
        if almacen['despacho'] == true
            @Espacio_Total_despacho = almacen['totalSpace']
            @Espacio_Usado_despacho = almacen['usedSpace']
        end

        if almacen['recepcion'] == true
            @Espacio_Total_recepcion = almacen['totalSpace']
            @Espacio_Usado_recepcion = almacen['usedSpace']
        end

        if almacen['pulmon'] == true
            @Espacio_Total_pulmon = almacen['totalSpace']
            @Espacio_Usado_pulmon = almacen['usedSpace']
        end

        if almacen['pulmon'] == false && almacen['recepcion'] == false && almacen['despacho'] == false
            @Espacio_Total_general1 = almacen['totalSpace']
            @Espacio_Usado_general1 = almacen['usedSpace']
            general1 = true
        end
        if almacen['pulmon'] == false && almacen['recepcion'] == false && almacen['despacho'] == false && general1
            @Espacio_Total_general2 = almacen['totalSpace']
            @Espacio_Usado_general2 = almacen['usedSpace']
        end
    end


end

end
