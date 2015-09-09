class FxController < ApplicationController	

	require 'open-uri'
	
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
				:instruments => "EUR_USD,AUD_USD,GBP_USD,USD_CAD,USD_JPY,AUD_JPY,NZD_USD,EUR_JPY,USD_SGD,AUD_SGD,XAU_USD"
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
			["btc_usd", "ltc_usd" , "ltc_btc" , "nmc_btc" ].each { |instrument|
				
				ticker_json = Btce::Ticker.new(instrument).json 
				obj = {}
				obj["instrument"] = instrument.upcase
				obj["bid" ] = ticker_json[instrument]["sell"]
				obj["ask" ] = ticker_json[instrument]["buy"]
				data << obj	
			}
				
			response_text = { :status => 0 , :statusmsg => "OK", :prices => data }

		rescue Exception => ex 

			response_text = {:status => -1 , :statusmsg => ex.to_s }
		end

		render :text => response_text.to_json
		

	end


	#---------------
	def fybsg 

		response_text = {}
		
		begin
			data = []
			fybsg = JSON.parse( open("https://www.fybsg.com/api/SGD/tickerdetailed.json" ).read )
			obj = {}
			obj["instrument"] = "BTC_SGD"
			obj["bid" ] = fybsg["bid"]
			obj["ask" ] = fybsg["ask"]
			data << obj	
			response_text = { :status => 0 , :statusmsg => "OK", :prices => data }

		rescue Exception => ex 

			response_text = {:status => -1 , :statusmsg => ex.to_s }
		end		
		render :text => response_text.to_json
		
	end

	#--------
	def cryptsy

		response_text = {}
		begin 
			data = []
			cryptsy = JSON.parse( open("https://www.cryptsy.com/orders/ajaxorderslist2/462").read )
				
			obj = {}
			obj["instrument"] = "CLAM_BTC"
			obj["ask"] = cryptsy["sell"].first[0]
			obj["bid"] = cryptsy["buy"].last[0]
			data << obj

			response_text = { :status => 0 , :statusmsg => "OK", :prices => data }

		rescue Exception => ex 
			response_text = {:status => -1 , :statusmsg => ex.to_s }
		end

		render :text => response_text.to_json
	end


	#----------------
	def sgx

		response_text = {}
		begin 
			data = []

			html = open("http://sgx.com/JsonRead/JsonData?qryId=RStock").read
			html.gsub!("{}&& ","").gsub!(/([a-zA-Z]+[0-9_]*):/,'"\1":').gsub!("'","\"")
			

			sgx = JSON.parse( html )
			counters = ["Duty Free Intl", "Mencast", "Asian Pay Tv Tr", "OCBC Bank", "Sheng Siong", "Second Chance", "M1", "SingTel", "StarHub", "Old Chang Kee", "Keppel Corp", "UMS", "Vard", "Global Logistic", "SingPost", "Nam Cheong", "Religare HTrust", "Spackman", "POSH", "IHC", "Ezion", "SIA", "DBS", "Frasers Cpt", "PNE Industries"];
			


			sgx["items"].each { |counter_obj|

				if counters.index( counter_obj["N"] )
					
					obj = {}
					obj["instrument"] = counter_obj["N"]
					obj["bid" ] = counter_obj["B"]
					obj["ask" ] = counter_obj["S"]
					data << obj	
				end	
			}
			response_text = { :status => 0 , :statusmsg => "OK", :prices => data }

		rescue Exception => ex 
			response_text = {:status => -1 , :statusmsg => ex.to_s }
		end

		render :text => response_text.to_json	
	end
end



















