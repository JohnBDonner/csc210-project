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
	        },
	        failure: function(dat) {
	        	console.log("failed");
	        },
	    });
	});

	// AJAX event for deleting a topic
	$(".topicItem").on("click", ".topicItem-delete", function() {
		// Do this before AJAX
		targetCSS_id = $(this).attr('id');
		targetTopic_id = targetCSS_id.match(/\d+/);
		deletedDiv = $(this).parent();
		// Upon success...
		// deletedDiv.append("<div class='topicDeleted-message'>Topic successfully deleted</div>");
		// Upon failure...
		// deletedDiv.append("<div class='topicDeleted-message'>Something went wrong, your topic was not deleted</div>");
		console.log("clicked div: "+$(this));
		console.log("id: "+targetTopic_id);

		$.ajax({
	        url: "deleteTopic.rb",
	        // post this data to the server ...
	        type: "DELETE",
	        // grab the id of the div
	        data: {
	        	targetTopic: targetCSS_id
	        },

	        // the script will also return data back to the browser, so
	        // handle it here ...
	        dataType: "json",
	        success: function(dat) {
	        	console.log(dat);
	        	console.log("id sent back: " + dat.deletedTopic_id);
	        	deletedDiv.empty();
	        	deletedDiv.append("<div class='topicDeleted-message'>"+dat.deletedTopic_title+" was successfully deleted.</div>");
	        },
	        failure: function(dat) {
	        	deletedDiv.append("<div class='topicDeleted-message'>Something went wrong, your topic was not deleted</div>");
	        },
	    });
	});

});
