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
    #Oc.recepcionarOc(id_boleta) #aceptar orden de compra de consumidor. NO SE SI VA O NO??
    Bodega.moverInsumo(sku.to_i, cantidad) #mover los insumos
    #Factura.crearBoleta(proveedor, cliente, total_plata) #emitir la boleta
    Bodega.despacharPedidoB2c(sku, cantidad, direccion, total_plata, id_boleta)
    @boleta.estado = "confirmada"
    @boleta.save
    
  end

  def fail
  end
end
