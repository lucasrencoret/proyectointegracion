
class HomeController < ApplicationController
  def index
  	@ordenes = Oc.uniq.pluck(:name)
  	#@facturas= Facturas.obtenerFactura(:id => params[:iD])

  	# <%= Factura.find_by(:id => params[:iD])%>

  end
	def almacen
		@almacenes = Bodega.getAlmacenes()
	end
  
  
end
