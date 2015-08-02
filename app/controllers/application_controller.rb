class ApplicationController < ActionController::Base
	protect_from_forgery

	#-----------------------------------------
	def params_to_querystring( params )

		kv = []
		params.keys.each { |key|
			kv << "#{key}=#{ CGI::escape( params[key] ) }"
		}
		return kv.join("&") 
	end

end







