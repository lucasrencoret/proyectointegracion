
class HomeController < ApplicationController
  def index
  	@almacenes = Bodega.getAlmacenes()
  	#@facturas= Facturas.obtenerFactura(:id => params[:iD])

  	# <%= Factura.find_by(:id => params[:iD])%>

  end
  
  
end
