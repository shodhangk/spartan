Rails.application.routes.draw do
	root 'welocome#index'

	# require "resque_web"
	# mount ResqueWeb::Engine => "/resque_web"
	
	controller :customer do
		get '/get_customers' => :customers
	end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
