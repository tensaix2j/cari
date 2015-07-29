

function Fx() {

	this.init = function() {

		this.request_data();
	}

	//---------------------
	this.request_data = function( ) {

		var fx = this;
		var url = "/fx/oanda"
		var params = {}

		$("#threadindex_loadmore").html( "<a class='cssload-loader'><span class='cssload-loader-inner'></span></a>");

		$.getJSON( url , params , function( data ) {

			if ( data["status"] == -1 ) {
				fx.append_error( data );	
			} else {
				fx.append_data( data );
			}
			$("#threadindex_loadmore").hide();
		});


	}

	//-----------------
	this.append_error = function( data ) {

		var ul = $("#fx_list");
		var li = sprintf( "\
					<li>\
						<a class='threadindex_a'>\
							%s\
						</a>\
					</li>",
				 data["statusmsg"] );
					
		ul.append( $(li) );	
	}

	

	//-----------------
	this.append_data = function( data ) {

		
		var ul = $("#fx_list");

		for ( i = 0 ; i < data["prices"].length ; i++ ) {

			obj = data["prices"][i];

			var fx_pair = obj["instrument"];
			var bid     = obj["bid"];
			var ask 	= obj["ask"];

			var li = sprintf( "\
					<li>\
						<a class='threadindex_a'>\
							%s, Bid <b>%s</b>, Ask :<b>%s</b>\
						</a>\
					</li>",
				 fx_pair,  bid , ask );
					
			ul.append( $(li) );
		}
	}

}

