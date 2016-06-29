class CreateEstados < ActiveRecord::Migration
  def change
    create_table :estados do |t|
      t.integer :sku
      t.integer :stock

      t.timestamps null: false
    end
  end
end
