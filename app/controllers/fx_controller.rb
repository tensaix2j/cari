class FxController < ApplicationController	

	

	#-----------------------
	def index
		
	end

	
	
	#-----------------
	def oanda 	
		
		url 		= "https://api-fxtrade.oanda.com/v1/prices?"
		oanda_yml   = "#{ Rails.root }/config/oanda.yml"

		if File.exists?(oanda_yml)
			
			oanda_account = YAML.load_file(oanda_yml)[Rails.env]
			params = { 
				:accountId 	=> oanda_account["id"].to_s,
				:instruments => "EUR_USD,AUD_USD,GBP_USD,USD_JPY"
			}

			begin 
				response_text = open(url + params_to_querystring(params) , "Authorization" => oanda_account["token"].to_s ).read
			rescue Exception => ex 
				response_text = {:status => -1 , :statusmsg => ex.to_s }.to_json()
			end

		else
			response_text = {:status => -1 , :statusmsg => "Oanda configuration (oanda.yml) is required" }.to_json()
		
		end
				
		
		render :text => response_text

	end

end
