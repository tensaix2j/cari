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

	#-------------
	def open_url_read( url , html )

		begin 
			open(url) { |f|
				while !f.eof
					begin 
						html << f.gets.chomp()
					rescue Exception => ex
						puts "#{ ex.to_s }"
					end
				end
			}
		
		rescue Exception => ex
			puts "#{ ex.to_s }"
		end

	end



end







