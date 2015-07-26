	

	function Thread () {

		//--------------------------
		this.init = function() {
			
			var th = this;
			$("#post_loadmore").click( function() {
					
				var url  = "/sg/thread_json" ;
				var params = { 
					tid  : th.tid,
					page : th.pageloaded + 1
				};
				
				$("#post_loadmore").html( "<a class='cssload-loader'><span class='cssload-loader-inner'></span></a>");
				

				$.getJSON( url , params , function( data ) {

					th.append_data( data );
					th.pageloaded = th.pageloaded + 1;

					$("#post_loadmore").html( "More...");
					
					if ( th.pageloaded >= th.maxpage ) {
						$("#post_loadmore").hide();
					}
					
				});


			});
		}


		//------------
		this.append_data = function( data ) {

			var ul = $("#post_list");
			for ( var i = 0 ; i < data.length ; i++ ) {

				post_id , post_author, post_date, post_text

				var post_id 		= data[i][0];
				var post_author 	= data[i][1];
				var post_date 		= data[i][2];
				var post_text 		= data[i][3];
				
				
				var li = sprintf("\
					<li>\
						<div class='post'>\
							<div class='post_details'><b>%s</b>, <b>%s</b></div>\
							<div class='post_text'>%s</div>\
						</a>\
					</li>", post_author, post_date, post_text );
					
				ul.append( $(li) );
				ul.find('#post_loadmore').appendTo(ul);
				
			}
		}
	}



