


	function Threadindex () {

		//--------------------------
		this.init = function() {
			
			var ti = this;
			$("#threadindex_loadmore").click( function() {
				
				var url  = "/sg/index_json" ;
				var params = { 
					page : ti.pageloaded + 1
				};

				$("#threadindex_loadmore").html( "<a class='cssload-loader'><span class='cssload-loader-inner'></span></a>");
				

				$.getJSON( url , params , function( data ) {

					ti.append_data( data );
					ti.pageloaded = ti.pageloaded + 1;
					

					$("#threadindex_loadmore").html( "More...");
				

				});

			});
		}

		//------------
		this.append_data = function( data ) {

			var ul = $("#threadindex_list");
			for ( var i = 0 ; i < data.length ; i++ ) {

				var tid 			= data[i][0];
				var author 			= data[i][1];
				var lastpostby 		= data[i][2];
				var title 			= data[i][3];
				var lastpostdate 	= data[i][4];
				var replies 		= data[i][5];
				
				var li = sprintf( "\
					<li>\
						<a href='/sg/thread?tid=%s' class='threadindex_a'>\
							<div class='threadindex_title'><b>%s</b></div>\
							<div class='threadindex_details'>By: <b>%s</b>, Last: <b>%s</b>, %s, %s replies.</div>\
						</a>\
					</li>",
				 tid, title, author, lastpostby , lastpostdate , replies );
					
				ul.append( $(li) );

				ul.find('#threadindex_loadmore').appendTo(ul);
					 	
			}
		}
	}

