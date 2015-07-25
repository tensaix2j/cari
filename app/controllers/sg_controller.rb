

class SgController < ApplicationController

	#-----------	
	def index

		
		url 	= "http://cforum.cari.com.my/forum.php?mod=forumdisplay&fid=159"
		html 	= open(url).read
		page = Nokogiri::HTML(html) 
		threads = page.xpath('//tbody[starts-with(@id, "normalthread_")]')

		@threads_arr = []

		threads.each { |thread|
			
			entry_id 		= thread.attributes["id"].value.split("_")[1]
			entry_title 	= thread.css("tr").css("th").css(".s").text
			
			users = thread.css(".by")
			entry_author = users[0].css("a").text 
			entry_lastpostuser = users[1].css("cite > a").text
			entry_lastpostdate = users[1].css("em > a").text



			@threads_arr << [ entry_id , entry_author, entry_lastpostuser, entry_title , entry_lastpostdate  ]

		}


	end

	#-------
	def thread

		@posts_arr = []
			
		if params[:tid] 

			page = params[:page] || 1
			url 	= "http://cforum.cari.com.my/forum.php?mod=viewthread&tid=#{ params[:tid] }&page=#{page}"
			html 	= open(url).read
			page = Nokogiri::HTML(html) 
			posts = page.xpath('//div[starts-with(@id, "post_")]')

			i = 0

			posts.each { |post|

				div_id = post.attributes["id"].value

				if div_id[/post_[0-9]*$/]

					post_id = post.attributes["id"].value.split("_")[1]
					post_author = post.css(".favatar .authi a").text
					post_date   = post.css("#authorposton#{ post_id }").text.gsub("发表于 ","")
					post_text = post.css("#postmessage_#{post_id}").inner_html.gsub("img src=\"static","img src=\"http://cforum.cari.com.my/static")


					p post_text if i == 4

					@posts_arr << [ post_id , post_author, post_date, post_text ]
				

					i += 1
				end	

				
			}


		end

	end

end







