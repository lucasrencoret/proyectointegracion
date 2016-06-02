class CreateBoleta < ActiveRecord::Migration
  def change
    create_table :boleta do |t|
      t.string :cliente
      t.string :proveedor
      t.integer :bruto
      t.integer :iva
      t.integer :total
      t.string :_id
      t.string :estado
      t.string :direccion
      t.integer :sku
      t.integer :cantidad

      t.timestamps null: false
    end
  end
end
