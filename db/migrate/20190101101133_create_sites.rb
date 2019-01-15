class CreateSites < ActiveRecord::Migration[5.2]
  def change
    create_table :sites do |t|
      t.string :organization_id, null:false
      t.string :site_id, null:false, index: {unique: true}
      t.string :name
      t.string :hp_region
      t.string :phone
      t.string :country
      t.timestamps
    end
  end
end
