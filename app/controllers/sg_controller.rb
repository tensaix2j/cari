

class SgController < ApplicationController
	
	require 'open-uri'
	#-----------	
	def index

		@threads_arr = []
		page 		= params[:page] || 1

		(page...(page+2)).each { |pg|			
			request_threadindex( pg, @threads_arr )		
			@pageloaded = pg
			if @threads_arr.count >= 30
				break
			end
		}
	end


	#----------
	def index_json

		@threads_arr = []
		page = params[:page] || 1
		request_threadindex( page,  @threads_arr )
		render :text => @threads_arr.to_json
	end





	#--------------
	def request_threadindex( page , threads_arr ) 

		url 		= "http://cforum.cari.com.my/forum.php?mod=forumdisplay&fid=159&page=#{page}"
		html 		= open(url).read
		nkgrhtml 	= Nokogiri::HTML(html) 
		threads 	= nkgrhtml.xpath('//tbody[starts-with(@id, "normalthread_")]')

		
		threads.each { |thread|
			
			entry_id 		= thread.attributes["id"].value.split("_")[1]
			entry_title 	= thread.css("tr").css("th").css(".s").text
			
			users = thread.css(".by")
			entry_author = users[0].css("a").text 
			entry_lastpostuser = users[1].css("cite > a").text
			entry_lastpostdate = users[1].css("em > a").text
			entry_postcount    = thread.css(".num a").text

			threads_arr << [ entry_id , entry_author, entry_lastpostuser, entry_title , entry_lastpostdate , entry_postcount ]
		}
	end





	#-------
	def thread

		@posts_arr = []
		
		if params[:tid] 

			page 		= params[:page] || 1
			request_thread( params[:tid] , page , @posts_arr )
			@tid 		= params[:tid]
		end

	end


	#----------
	def thread_json

		@posts_arr = []
		page = params[:page] || 1

		if params[:tid] 
			request_thread( params[:tid], page,  @posts_arr )
		end
	
		render :text => @posts_arr.to_json
	end


	#--------
	def cleanup_post_text( post_text )

		return post_text.gsub("img src=\"static","img src=\"http://cforum.cari.com.my/static").gsub("onmouseover=\"img_onmouseoverfunc(this)\"","").gsub("onload=\"thumbImg(this)\"","")
		
	end


	#-----
	def request_thread( tid, page , posts_arr ) 

		url 		= "http://cforum.cari.com.my/forum.php?mod=viewthread&tid=#{ tid }&page=#{page}"
		html 		= open(url).read
		nkgrhtml 	= Nokogiri::HTML(html) 
		posts 		= nkgrhtml.xpath('//div[starts-with(@id, "post_")]')

		@maxpage 	= nkgrhtml.css("#ct #pgt label span").text[3...-1].to_i


		posts.each { |post|

			div_id = post.attributes["id"].value

			if div_id[/post_[0-9]*$/]

				post_id = post.attributes["id"].value.split("_")[1]
				post_author = post.css(".favatar .authi a").text
				post_date   = post.css("#authorposton#{ post_id }").text.gsub("发表于 ","")
				post_text = cleanup_post_text( post.css("#postmessage_#{post_id}").inner_html ) 



				@posts_arr << [ post_id , post_author, post_date, post_text ]
			end	
		}


	end

end







