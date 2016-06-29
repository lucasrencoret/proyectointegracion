class CreateCuenta < ActiveRecord::Migration
  def change
    create_table :cuenta do |t|
      t.integer :saldo

      t.timestamps null: false
    end
  end
end
