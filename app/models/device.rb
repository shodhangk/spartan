include PrintosUtils
class Device < ApplicationRecord
	belongs_to :customer, primary_key: :organization_id, foreign_key: :organization_id, inverse_of: :devices
	belongs_to :site, primary_key: :site_id, foreign_key: :site_id, inverse_of: :devices, optional: true

	def self.import_devices_from_print_os
		get_devices
	end	
end	 

