class FxController < ApplicationController	

	

	#-----------------------
	def index
		
	end

	
	
	#-----------------
	def oanda 	
		
		url 		= "https://api-fxtrade.oanda.com/v1/prices?"
		oanda_yml   = "#{ Rails.root }/config/oanda.yml"
		response_text = {}

		if File.exists?(oanda_yml)
			
			oanda_account = YAML.load_file(oanda_yml)[Rails.env]
			params = { 
				:accountId 	=> oanda_account["id"].to_s ,
				:instruments => "EUR_USD,AUD_USD,GBP_USD,USD_CAD,USD_JPY,AUD_JPY,EUR_JPY,USD_SGD,AUD_SGD"
			}

			begin 
				response_text = JSON.parse( open(url + params_to_querystring(params) , "Authorization" => oanda_account["token"].to_s ).read )
				response_text[:status] = 0
				response_text[:statusmsg] = "OK"
					

			rescue Exception => ex 
				response_text = {:status => -1 , :statusmsg => ex.to_s }
			end

		else
			response_text = {:status => -1 , :statusmsg => "Oanda configuration (oanda.yml) is required" }
		
		end
				
		
		render :text => response_text.to_json

	end


	#---------------
	def btce 

		response_text = {}
		begin
			data = []
			["btc_usd", "ltc_usd"].each { |instrument|
				
				ticker_json = Btce::Ticker.new(instrument).json 
				obj = {}
				obj["instrument"] = instrument.upcase
				obj["bid" ] = ticker_json[instrument]["buy"]
				obj["ask" ] = ticker_json[instrument]["sell"]
				data << obj	
			}
				
			response_text = { :status => 0 , :statusmsg => "OK", :prices => data }

		rescue Exception => ex 

			response_text = {:status => -1 , :statusmsg => ex.to_s }
		end

		render :text => response_text.to_json
		

	end
end


















