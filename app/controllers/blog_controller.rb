class BlogController < ApplicationController	

	require 'open-uri'
	require 'time'


	#----------------
	def ronald
		
	end

	#---------------------------
	def ronald_newer
		
		year 		= params[:year]
		month 		= params[:month]
		topics 		= []
	
		if year && month 
		
			url 		= "http://stockmarketmindgames.blogspot.sg"
			fmt_month 	= "%02d" % month

			params 		= {
				"action" => "getTitles",
				"responseType" => "js",
				"widgetId" => "BlogArchive1",
				"path" => "http://stockmarketmindgames.blogspot.sg/#{year}_#{fmt_month}_01_archive.html"
			}
			html 		= ""
			open_url_read( url + "?" + params_to_querystring( params) , html )			
			html.gsub!( "try {_WidgetManager._HandleControllerResult('BlogArchive1', 'getTitles',{'path': 'http://stockmarketmindgames.blogspot.sg/#{year}_#{fmt_month}_01_archive.html', 'posts': ", "")
			html.gsub!( "});} catch (e) {  if (typeof log != 'undefined') {    log('HandleControllerResult failed: ' + e);  }}" , "" )
			html.gsub!( "'", "\"")
			
			begin
				topics = JSON.parse( html )
			rescue Exception => ex 
				puts  t.strftime("%Y%m")
			end
		end	
		
		render :text =>  topics.to_json

	end	


end


