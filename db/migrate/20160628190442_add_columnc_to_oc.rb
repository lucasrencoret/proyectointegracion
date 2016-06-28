class AddColumncToOc < ActiveRecord::Migration
  def change
    add_column :ocs, :tipo, :string
  end
end
