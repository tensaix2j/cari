class SgController < ApplicationController	

	require 'open-uri'
	
	
	#----------------
	def controller_to_fid() 

		@controller = params[:controller] if @controller == nil

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
			:gamedev => 334,
			:entrepreneur => 242
		}

		@controller_to_label = {
			:sg => "新加坡",
			:forex => "外匯",
			:movie => "影視",
			:politic => "國內政治",
			:world => "世界",
			:office => "辦公",
			:astrology => "玄學",
			:buddhism => "佛學",
			:gossip => "吱喳",
			:love => "愛情",
			:bizarre => "不可思議",
			:stock => "股票",
			:iphone => "iPhone",
			:samsung => "Samsung",
			:developer => "軟件開發",
			:gamedev => "遊戲開發",
			:entrepreneur => "創業"
		}	

		return @controller_to_fid[@controller.to_sym] || 159

	end


	#----------------
	def default 

		a,@controller,@action = request.path.split("/")
		@action = "index" if @action == nil

		begin
			method( @action ).call()
		rescue Exception=>ex 
			redirect_to  "/sg/menu"
		end
				
	end

	#---------
	def menu

		controller_to_fid

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

				cari_imgs = []

				begin
					post.css("ignore_js_op").each { | ignore_js_op|
						
						cari_img_src = ""
						if ignore_js_op.css("img") && ignore_js_op.css("img")[0].attributes["file"]
							cari_img_src =  ignore_js_op.css("img")[0].attributes["file"].value 
						elsif ignore_js_op.css(".savephotop img") && ignore_js_op.css(".savephotop img")[0].attributes["file"]
							cari_img_src =  ignore_js_op.css(".savephotop img")[0].attributes["file"].value
						end
						cari_imgs << "<img src=#{cari_img_src} />"
					}
				rescue Exception => ex
					puts "Error #{ ex.to_s }"
				end

				post_text = cleanup_post_text( post.css("#postmessage_#{post_id}").inner_html ) 
				post_text += "<div>#{ cari_imgs.join("") }</div>" if cari_imgs.length > 0
				
				@posts_arr << [ post_id , post_author, post_date, post_text ]
				
				

			end	
		}


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


