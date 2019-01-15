include PrintosUtils
class Site < ApplicationRecord
	has_many :devices, primary_key: :site_id, foreign_key: :site_id, dependent: :destroy, inverse_of: :site
	belongs_to :customer, primary_key: :organization_id, foreign_key: :organization_id, inverse_of: :sites

	def self.import_sites_from_print_os
		get_sites
	end	
end
