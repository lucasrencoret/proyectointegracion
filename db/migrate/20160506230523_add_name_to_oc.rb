class AddNameToOc < ActiveRecord::Migration
  def change
    add_column :ocs, :name, :string
  end
end
