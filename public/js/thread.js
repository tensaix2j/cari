	

	function Thread () {

		//--------------------------
		this.init = function() {
			
			this.register_loadmore();

		}


		//------------
		this.register_loadmore = function() {
			
			var th = this;
			$("#post_loadmorefirst").click( function() {
				th.loadmorefirst_onclick();
			});
			$("#post_loadmorelast").click( function() {
				th.loadmorelast_onclick();
			});
		}
		


		//----------------------------------------
		this.loadmorefirst_onclick = function() {

			var page_to_load = 0;
			for ( var pg = 0 ; pg < this.maxpage ; pg++ ) {
				if ( this.pageloaded[pg] == null ) {
					page_to_load = pg;
					break;
				}
			}
			this.request_page( page_to_load );

		}

		//-------------
		this.loadmorelast_onclick = function() {
			
			var page_to_load = this.maxpage - 1;
			for ( var pg = this.maxpage - 1 ; pg > 0 ; pg-- ) {
				if ( this.pageloaded[pg] == null ) {
					page_to_load = pg;
					break;
				}
			}
			this.request_page( page_to_load );	
		}



		//---------------------
		this.request_page = function( page_to_load ) {

			var url  =  sprintf("/%s/thread_json", this.controller ) ;
			var params = { 
				tid  : this.tid,
				page : page_to_load + 1
			};
			
			$("#post_loadmore").html( "<a class='cssload-loader'><span class='cssload-loader-inner'></span></a>");
			
			var th = this;
			$.getJSON( url , params , function( data ) {

				th.append_data( data , page_to_load );
				th.pageloaded[page_to_load] = 1;

				$("#post_loadmore").html( "\
						<div id='post_loadmorefirst'>More From First ...</div>\
						<div id='post_loadmorelast'>... More From Last</div>\
					");

				th.register_loadmore();

				if ( th.all_pages_loaded() ) {
					$("#post_loadmore").hide();
				}
			});
		}


		//-----------------
		this.all_pages_loaded = function() {

			for ( var i = 0 ; i < this.maxpage ; i++ ) {
				if ( this.pageloaded[i]  == null) {
					return false;
				}
			}
			return true;
		}



		//------------
		this.append_data = function( data , page ) {

			var ul = $("#post_list");
			var li_last_of_prev_page = $(".li_pg_" + (page - 1) + ":last");
			var li_loadmore = $("#post_loadmore");

			for ( var i = data.length - 1 ; i >= 0 ; i-- ) {

				post_id , post_author, post_date, post_text

				var post_id 		= data[i][0];
				var post_author 	= data[i][1];
				var post_date 		= data[i][2];
				var post_text 		= data[i][3];
				
				
				var li = sprintf("\
					<li class='li_pg_%s'>\
						<div class='post'>\
							<div class='post_details'><b>%s</b>, <b>%s</b></div>\
							<div class='post_text'>%s</div>\
						</a>\
					</li>", page  , post_author, post_date, post_text );
					
					
				if ( li_last_of_prev_page.length == 1 ) {
					$(li).insertAfter( li_last_of_prev_page );	
				} else {
					$(li).insertAfter( li_loadmore );	
				}			
			}
		}
	}



