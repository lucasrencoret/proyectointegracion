class CreateOcs < ActiveRecord::Migration
  def change
    create_table :ocs do |t|

      t.timestamps null: false
    end
  end
end
