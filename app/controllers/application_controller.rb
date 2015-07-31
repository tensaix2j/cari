class ApplicationController < ActionController::Base
	protect_from_forgery

	require 'open-uri'
	
	#----------------
	def controller_to_fid() 

		@controller = params[:controller]

		@controller_to_fid = {
			:sg => 159,
			:forex => 89,
			:movie => 20,
			:politic => 562,
			:world => 564,
			:office => 49,
			:astrology => 288,
			:buddhism => 87,
			:gossip => 9,
			:love => 10,
			:bizarre => 142,
			:stock => 537,
			:iphone => 644,
			:samsung => 662,
			:developer => 113,
			:gamedev => 334
		}	
				
		return @controller_to_fid[@controller.to_sym] || 159

	end

	#-----------	
	def index

		@threads_arr = []
		fid 		= controller_to_fid()
		page 		= params[:page] || 1

		(page...(page+2)).each { |pg|			
			request_threadindex( fid, pg, @threads_arr )		
			@pageloaded = pg
			if @threads_arr.count >= 30
				break
			end
		}
		render :template => "/sg/index"
	end


	#----------
	def index_json

		@threads_arr = []
		fid  = controller_to_fid()
		page = params[:page] || 1
		request_threadindex( fid, page,  @threads_arr )
		render :text => @threads_arr.to_json
	end





	#--------------
	def request_threadindex( fid, page , threads_arr ) 

		url 		= "http://cforum.cari.com.my/forum.php?mod=forumdisplay&fid=#{ fid }&page=#{ page }"
		html 		= ""
		open_url_read( url, html )		
		
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
		fid 	= controller_to_fid()

		if params[:tid] 

			page 		= params[:page] || 1
			request_thread( params[:tid] , page , @posts_arr )
			@tid 		= params[:tid]
		
		else
			redirect_to :action => :index
		end

		render :template => "/sg/thread"
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

		return post_text
						.gsub("src=\"static","src=\"http://cforum.cari.com.my/static")
						.gsub("onmouseover=\"img_onmouseoverfunc(this)\"","")
						.gsub("onload=\"thumbImg(this)\"","")
		
	end

	#-------------
	def open_url_read( url , html )

		open(url) { |f|
			while !f.eof
				begin 
					html << f.gets.chomp()
				rescue Exception => ex
					puts "#{ ex.to_s }"
				end
			end
		}
	end


	#-----
	def request_thread( tid, page , posts_arr ) 

		url 		= "http://cforum.cari.com.my/forum.php?mod=viewthread&tid=#{ tid }&page=#{page}"
			
		html = ""
		open_url_read( url, html )		
		
		nkgrhtml 	= Nokogiri::HTML(html) 
		posts 		= nkgrhtml.xpath('//div[starts-with(@id, "post_")]')

		@maxpage 	= nkgrhtml.css("#ct #pgt label span").text[3...-1].to_i
		@thread_title = nkgrhtml.css("#thread_subject").text 
		

		posts.each { |post|

			div_id = post.attributes["id"].value

			if div_id[/post_[0-9]*$/]

				post_id = post.attributes["id"].value.split("_")[1]
				post_author = post.css(".favatar .authi a").text
				post_date   = post.css("#authorposton#{ post_id }").text.gsub("发表于 ","")

				begin
					post.css("ignore_js_op").each { | ignore_js_op|
					
						cari_img_src =  ignore_js_op.css("img")[0].attributes["file"].value
						ignore_js_op.inner_html = "<img src=#{cari_img_src} />"
					}
				rescue
				end

				post_text = cleanup_post_text( post.css("#postmessage_#{post_id}").inner_html ) 
				@posts_arr << [ post_id , post_author, post_date, post_text ]
			end	
		}


	end

	
	#-----------------------------------------
	def params_to_querystring( params )

		kv = []
		params.keys.each { |key|
			kv << "#{key}=#{ CGI::escape( params[key] ) }"
		}
		return kv.join("&") 
	end


	#-------------------
	def reply

		if params[:tid] 

			fid 	= controller_to_fid()
			@tid = params[:tid]
					
			render :template => "/sg/reply"
		
		else
			render :text => ""
		end

	end
end







