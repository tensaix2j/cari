class BlogController < ApplicationController	

	require 'open-uri'
	
	#---------------------------
	def ronald

		url 		= "http://stockmarketmindgames.blogspot.sg"

		year 		= 2015
		month 		= 8
		fmt_month 	= "%02d" % month

		params 		= {
			"action" => "getTitles",
			"responseType" => "js",
			"widgetId" => "BlogArchive1",
			"path" => "http://stockmarketmindgames.blogspot.sg/#{year}_#{fmt_month}_01_archive.html"
		}
		html 		= ""
		open_url_read( url + "?" + params_to_querystring( params) , html )			

		html.gsub!( "try {_WidgetManager._HandleControllerResult('BlogArchive1', 'getTitles',{'path': 'http://stockmarketmindgames.blogspot.sg/2015_08_01_archive.html', 'posts': ", "")
		html.gsub!( "});} catch (e) {  if (typeof log != 'undefined') {    log('HandleControllerResult failed: ' + e);  }}" , "" )
		html.gsub!( "'", "\"")
		arr = JSON.parse( html )

		render :text =>  arr.to_json

	end	


end


