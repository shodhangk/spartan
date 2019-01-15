class CustomerController < ApplicationController

 def customers
  customers_data = []
  Device.all.includes(:site, :customer).each do |i_device|
   customers_data << {
    customer_name: i_device.customer.name,
    main_contact: "John Doe",
    phone_number: i_device.site.nil? ? "--" : (i_device.site.phone.nil? ? "--" : i_device.site.phone),
    country: i_device.site.nil? ? "--" : (i_device.site.country.nil? ? "--" : i_device.site.country),
    region: i_device.site.nil? ? "--" : (i_device.site.hp_region.nil? ? "--" : i_device.site.hp_region),
    send_files: "--",
    scheduled_visit: "--",
    r2p_status: "--",
    serial_number: i_device.serial_number.nil? ? "--" : i_device.serial_number,
    product_number: i_device.product_number.nil? ? "--" : i_device.product_number  
   }
  end
  render json: {customers: customers_data}
 end

end
