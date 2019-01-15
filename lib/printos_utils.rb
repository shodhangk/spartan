module PrintosUtils
	include NetHttpHelper

	def service_login(request_body)
		url = URI("#{base_url}/api/aaa/v4/services/login")
		http = generate_http_request(url)
		post_request = generate_post_request(url)
		post_request.body = request_body.to_json
		post_request['Content-Type'] = "application/json"
		response = http.request(post_request)
		response
	end

	def base_url
		PRINTOS_OPTIONS[:base_url]
	end

	def sms_cookie_key
		'Indigo-SmS-Auth-Token'
	end

	def get_customers
		offset = 0
		auth_token = get_services_token
		http, get_request = get_organizations_request(offset, auth_token)
		response = http.request(get_request)
		if response.kind_of?(Net::HTTPSuccess)
			initial_response = JSON.parse(response.body)
			total = initial_response["total"]
			organizations = initial_response["organizations"]
			create_customers(organizations)
			unless (total < 1000)
				steps = total/1000
				(1..steps).each do |i|
					offset += 1000
					http, get_request = get_organizations_request(offset, auth_token)
					response = http.request(get_request)
					if response.kind_of?(Net::HTTPSuccess)
						further_response = JSON.parse(response.body)
						organizations = further_response["organizations"]
						create_customers(organizations)
					end
				end
			end
		end
	end

	def create_customers(organizations)
		customers = []
		organizations.each do |organization|
			if !Customer.where(organization_id: organization["organizationId"]).exists?
				customers << {
					organization_id: organization["organizationId"],
					name: organization["name"],
					customer_type: organization["type"],
				}
			end
		end
		Customer.create(customers) unless customers.blank?
	end

	def get_sites
		auth_token = get_services_token
		organization_ids = Customer.pluck(:organization_id)
		organization_ids.each do |organization_id|
			http, get_request = get_sites_request(organization_id, auth_token)
			response = http.request(get_request)
			if response.kind_of?(Net::HTTPSuccess) 
				sites_body = JSON.parse(response.body)
				sites_info = sites_body["sites"]
				create_sites(sites_info)
			end
		end  
	end

	def create_sites(sites_info)
		sites = []
		sites_info.each do |site|
			if !Site.where(site_id: site["siteId"]).exists?
				sites << {
					organization_id: site["organizationId"],
					site_id: site["siteId"],
					name: site["name"],
					hp_region: site["hpRegion"],
					phone: site["primaryPhone"],
					country: !site["primaryAddress"].blank? ? site["primaryAddress"]["country"] : nil
				}
			end
		end
		Site.create(sites) unless sites.blank?
	end

	def get_devices
		offset = 0
		auth_token = get_services_token
		http, get_request = get_devices_request(offset, auth_token)
		response = http.request(get_request)
		if response.kind_of?(Net::HTTPSuccess)
			initial_response = JSON.parse(response.body)
			total = initial_response["total"]
			devices = initial_response["devices"]
			create_devices(devices)
			unless (total < 1000)
				steps = total/1000
				(1..steps).each do |i|
					offset += 1000
					http, get_request = get_devices_request(offset, auth_token)
					response = http.request(get_request)
					if response.kind_of?(Net::HTTPSuccess)
						further_response = JSON.parse(response.body)
						devices = further_response["devices"]
						create_devices(devices)
					end
				end
			end
		end
	end

	def create_devices(devices_info)
	# byebug
	devices = []
	devices_info.each do |device|
		if !Device.where(device_id: device["deviceId"]).exists?
			devices << {
				organization_id: device["organizationId"],
				name: device["name"],
				device_id: device["deviceId"],
				serial_number: device["serialNumber"],
				site_id: !device["site"].blank? ? device["site"]["siteId"] : nil
			}
		end
	end
	p "anju "*10
	p devices
	Device.create(devices) unless devices.blank?
end

def get_organizations_request(offset, auth_token)
	url = URI("#{customer_url}limit=1000&offset=#{offset}")
	request = compute_get_request(url, auth_token)
	request
end

def get_sites_request(organization_id, auth_token)
	url = URI("#{sites_url(organization_id)}")
	request = compute_get_request(url, auth_token)
	request
end

def get_devices_request(offset, auth_token)
	url = URI("#{device_url}limit=1000&offset=#{offset}")
	request = compute_get_request(url, auth_token)
	request
end

def compute_get_request(url, auth_token)
	http = generate_http_request(url)
	get_request = generate_get_request(url)
	get_request.add_field('Cookie', "#{sms_cookie_key}=#{auth_token}")
	return http, get_request
end

def get_auth_token_from_response(response)
	cookie_token = JSON.parse(response.body)['authToken']
	cookie_token
end

def get_services_token
	request_body = {login: PRINTOS_OPTIONS[:ss_user], password: PRINTOS_OPTIONS[:ss_password]}
	response = service_login(request_body)
	get_auth_token_from_response(response) if response.code.to_i == 200
end

def customer_url
	"#{PRINTOS_OPTIONS[:base_url]}/api/aaa/#{URL_VERSION}/admin/organizations/?"
end

def sites_url(organization_id)
	"#{PRINTOS_OPTIONS[:base_url]}/api/aaa/#{URL_VERSION}/admin/organizations/#{organization_id}/sites"
end

def device_url
	"#{PRINTOS_OPTIONS[:base_url]}/api/aaa/#{URL_VERSION}/admin/devices/?"
end

end

