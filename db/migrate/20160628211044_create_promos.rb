class CreatePromos < ActiveRecord::Migration
  def change
    create_table :promos do |t|
      t.string :sku
      t.integer :precio
      t.datetime :inicio
      t.datetime :fin
      t.string :codigo  
      t.timestamps null: false
    end
  end
end