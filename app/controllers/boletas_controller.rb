class BoletasController < ApplicationController
  def ok
    id_boleta = params[:_id]
    @boleta = B2c.find_by _id: id_boleta
    
    #MANDAR A DESPACHAR
    direccion = @boleta.direccion
    sku = @boleta.sku
    cantidad = @boleta.cantidad
    id_boleta = @boleta._id
    total_plata = @boleta.total
    iva = @boleta.iva
    bruto = @boleta.bruto
    proveedor = @boleta.proveedor
    cliente = @boleta.cliente
    
    
  end

  def fail
  end
end
