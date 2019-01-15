class AddSerialAndProductNumberToDevice < ActiveRecord::Migration[5.2]
  def change
  	add_column :devices, :serial_number, :string
  	add_column :devices, :product_number, :string
  end
end
