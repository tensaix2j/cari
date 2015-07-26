	

	function Thread () {

		//--------------------------
		this.init = function() {
			
			var th = this;
			$(".morelink").click( function() {
				
				var url  = "/sg/thread_json" ;
				var params = { 
					tid  : th.tid,
					page : th.pageloaded + 1
				};
				$(".morelink").hide();
				$(".cssload-loader").show();


				$.getJSON( url , params , function( data ) {

					th.append_data( data );
					th.pageloaded = th.pageloaded + 1;

					if ( th.pageloaded < th.maxpage ) {
						$(".morelink").show();
					}
					$(".cssload-loader").hide();
				});

			});
		}


		//------------
		this.append_data = function( data ) {

			var tbody = $("#thread_tbody");
			for ( var i = 0 ; i < data.length ; i++ ) {

				post_id , post_author, post_date, post_text

				var post_id 		= data[i][0];
				var post_author 	= data[i][1];
				var post_date 		= data[i][2];
				var post_text 		= data[i][3];
				
				row = sprintf( "<tr> <td>%s</td> <td>%s</td> <td>%s</td> </tr>", post_author, post_date, post_text );
				tbody.append( $(row) );

			}
		}
	}