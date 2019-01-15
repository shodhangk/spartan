require 'uri'
require 'net/https'

module NetHttpHelper

    def generate_http_request(http_url)
        new_http = Net::HTTP.new(http_url.host, http_url.port, HTTP_PROXY.host, HTTP_PROXY.port)
        new_http.use_ssl = http_url.scheme == "https"
    # new_http.verify_mode = OpenSSL::SSL::VERIFY_NONE
   # new_http.set_debug_output $stderr # for debugging purpose
   return new_http
end

def generate_post_request(post_url, post_params={})
    new_request = Net::HTTP::Post.new(post_url.path)
    new_request.set_form_data(post_params) unless post_params.empty?
    return new_request
end

def generate_get_request(get_url, get_params={})
    new_request = Net::HTTP::Get.new(self.path_with_query_string(get_url), get_params)
    return new_request
end

def path_with_query_string(uri)
    path = uri.path
    path += "?#{uri.query}" if uri.query
    path
end

end