class AddTotalToOc < ActiveRecord::Migration
  def change
    add_column :ocs, :total, :integer
  end
end
