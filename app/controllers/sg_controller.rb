

class SgController < ApplicationController

	
	def index

		require 'open-uri'
		require 'nokogiri'
		require 'iconv'


		url 	= "http://cforum.cari.com.my/forum.php?mod=forumdisplay&fid=159"
		html 	= open(url).read

		page = Nokogiri::HTML(html) 
		threads = page.xpath('//tbody[starts-with(@id, "normalthread_")]')

		threads_arr = []

		threads.each { |thread|
			
			entry_title = Iconv.conv('utf-8', 'gbk', thread.css("tr").css("th").css(".s").text )
			threads_arr << entry_title

		}
		

		render :text => threads_arr.to_json()



	end

end
