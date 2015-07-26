


	function Threadindex () {

		//--------------------------
		this.init = function() {
			
			var ti = this;
			$(".morelink").click( function() {
				
				var url  = "/sg/index_json" ;
				var params = { 
					page : ti.pageloaded + 1
				};
				$(".morelink").hide();
				$(".cssload-loader").show();



				$.getJSON( url , params , function( data ) {

					ti.append_data( data );
					ti.pageloaded = ti.pageloaded + 1;
					$(".morelink").show();
					$(".cssload-loader").hide();
				
				});

			});
		}

		//------------
		this.append_data = function( data ) {

			var tbody = $("#threadindex_tbody");
			for ( var i = 0 ; i < data.length ; i++ ) {

				var tid 			= data[i][0];
				var author 			= data[i][1];
				var lastpostby 		= data[i][2];
				var title 			= data[i][3];
				var lastpostdate 	= data[i][4];
				
				var fmt_title  		= sprintf("<a href='/sg/thread?tid=%s'>%s</a>", tid, title );
				row = sprintf( "<tr> <td>%s</td> <td>%s</td> <td>%s</td> <td>%s</td> </tr>", author, lastpostby, fmt_title , lastpostdate );
				
				tbody.append( $(row) );

			}
		}
	}