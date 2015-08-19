

function Blog() {

	this.request_queue = [];

	this.init = function() {

		
		this.request_queue.push("/json/blog/ronald.json");
		this.process_request_queue();

	}

	//-------------
	this.process_request_queue = function( ) {

		if ( this.request_queue.length > 0 ) {
			var url = this.request_queue.shift();
			this.request_data( url );
		}
	}

	//---------------------
	this.request_data = function( url ) {

		var obj = this;
		var params = {}

		$("#threadindex_loadmore").html( "<a class='cssload-loader'><span class='cssload-loader-inner'></span></a>");
		$("#threadindex_loadmore").show();

		$.getJSON( url , params , function( data ) {

			if ( data["status"] == -1 ) {
				obj.append_error( data );	
			} else {
				obj.append_data( data );
			}
		
			$("#threadindex_loadmore").hide();
			obj.process_request_queue();

		});


	}

	//-----------------
	this.append_error = function( data ) {

		var ul = $("#topic_list");
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

		
		var ul = $("#topic_list");

		for ( i = 0 ; i < data.length ; i++ ) {

			obj = data[i];

			var title 	= obj["title"];
			var url     = obj["url"];
			
			var li = sprintf( "\
					<li>\
						<a href='%s' class='threadindex_a'>\
							%s \
						</a>\
					</li>",
				url, title );
					
			ul.append( $(li) );
			ul.find('#threadindex_loadmore').appendTo(ul);
		}
	}

}

