class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices do |t|
      t.string :device_id, null:false, index: {unique: true}
      t.string :organization_id, null:false
      t.string :name
      t.timestamps
    end
  end
end
