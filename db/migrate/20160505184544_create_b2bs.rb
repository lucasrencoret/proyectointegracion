class CreateB2bs < ActiveRecord::Migration
  def change
    create_table :b2bs do |t|

      t.timestamps null: false
    end
  end
end
