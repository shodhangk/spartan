class AddSiteIdToDevice < ActiveRecord::Migration[5.2]
  def change
  	add_column :devices, :site_id, :string
  end
end
