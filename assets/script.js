// perform code when the document is ready
$(document).ready(function() {

	/***** Events for making user pages *****/

	/***** Events for editing your profile *****/

	// AJAX event for clicking the edit bio button
	$("#bio").on("click", "#inline-edit", function() {

		console.log("clicked edit");

	    $.ajax({
	        url: "about.rb",
	        // post this data to the server ...
	        type: "POST",

	        // the script will also return data back to the browser, so
	        // handle it here ...
	        dataType: "json",
	        success: function(dat) {
	        	$('#bio').empty();
	        	$('#bio').append('<textarea id="editBio" name="comments" cols="25" rows="5" placeholder="tell us a bit about yourself...">'+dat.bio+'</textarea>');
	        	$('#bio').append('<br><div id="inline-submit" style="display: inline-block"><a href="#">Submit</a></div>');
	        	console.dir(dat.bio);
	        	console.log(dat.bio);
	        },
	    });
	});

	// AJAX event for clicking the submit new bio button while editing
	$("#bio").on("click", "#inline-submit", function() {
		console.log("clicked submit");

		$.ajax({
	        url: "newBio.rb",
	        // post this data to the server ...
	        type: "POST",
	        // grab data from the stuffInput text box
	        data: {
	        	bioText: $("#editBio").val()
	        },

	        // the script will also return data back to the browser, so
	        // handle it here ...
	        dataType: "json",
	        success: function(dat) {
	        	$('#bio').empty();
	        	$('#bio').append('<p>bio: ' + dat.bio + ' <br><div id="inline-edit" style="display: inline-block"><a href="#">edit</a></div></p>');
	        	console.dir(dat.bio);
	        	console.log(dat.bio);
	        },
	        failure: function(dat) {
	        	console.log("failed");
	        },
	    });
	});

});
