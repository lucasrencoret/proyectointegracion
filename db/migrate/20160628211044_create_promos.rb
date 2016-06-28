class CreatePromos < ActiveRecord::Migration
  def change
    create_table :promos do |t|

      t.timestamps null: false
    end
  end
end
