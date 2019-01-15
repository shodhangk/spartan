include PrintosUtils
class Customer < ApplicationRecord
	has_many :devices, primary_key: :organization_id, foreign_key: :organization_id, dependent: :destroy, inverse_of: :customer
	has_many :sites, primary_key: :organization_id, foreign_key: :organization_id, dependent: :destroy, inverse_of: :customer

	def self.import_customers_from_print_os
		get_customers
	end	
end