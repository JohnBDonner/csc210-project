// perform code when the document is ready
$(document).ready(function() {

	/***** Events for making user pages *****/

	/***** Events for editing your profile *****/

	// AJAX event for clicking the edit bio button
	$("#bio").on("click", "#inline-edit", function() {

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

	// AJAX event for creating new post
	$("#newpost").on("click", ".createPost", function() {
		// Do this before AJAX
		$('#newpost').empty();
		$('#newpost').append('<textarea id="newPost-displayText" name="newPost" cols="50" rows="1" placeholder="Display text"></textarea>');
		$('#newpost').append('<textarea id="newPost-url" name="newPost" cols="80" rows="1" placeholder="Paste in a url here"></textarea>');
		$('#newpost').append('<br><div id="inline-cancel" style="display: inline-block"><a href="#">Cancel</a></div>');
	    $('#newpost').append('<br><div id="inline-submit" style="display: inline-block"><a href="#">Submit</a></div>');

		$("#newpost").on("click", "#inline-submit", function() {
			targetCSS_id = $('.topic').attr('id');
			targetTopic_id = targetCSS_id.match(/\d+/);
			
			if ( ($("#newPost-displayText").val() != null && $("#newPost-url").val() != null) && ($("#newPost-displayText").val() != "" && $("#newPost-url").val() != "") ) {
				$.ajax({
			        url: "createPost.rb",
			        // post this data to the server ...
			        type: "POST",
			        // grab data from the stuffInput text box
			        data: {
			        	topic_id: targetCSS_id,
			        	post_content: $("#newPost-displayText").val(),
			        	post_url: $("#newPost-url").val()
			        },

			        // the script will also return data back to the browser, so
			        // handle it here ...
			        dataType: "json",
			        success: function(dat) {
			        	window.location.reload(true);
			        	/*
			        	$('#newpost').empty();
			        	$('#newpost').append('<div class="createPost-div"><a class="createPost" href="#">Add new link</a></div>');
			        	$('#posts').append('<a href="' + dat.post_url + '">' + dat.post_content + ' <a/><div id="inline-edit" style="display: inline-block"> | <a href="#">edit</a></div></p>');
			        	*/
			        },
			        failure: function(dat) {
			        	console.log("failed");
			        },
			    });
			}

		});

		$("#newpost").on("click", "#inline-cancel", function() {
			$('#newpost').empty();
			$('#newpost').append('<a class="createPost" href="#">Add new link</a>');
		});
		
	});

	// AJAX event for upvoting
	$(".postItem").on("click", ".upvote-link", function() {
		
		targetPost_id = $($(this).parent().parent()).attr('id');
		targetTopic_id = $('.topic').attr('id');
		
		$.ajax({
	        url: "newVote.rb",
	        // post this data to the server ...
	        type: "POST",
	        // grab data from the stuffInput text box
	        data: {
	        	topic_id: targetTopic_id,
	        	post_id: targetPost_id
	        },

	        // the script will also return data back to the browser, so
	        // handle it here ...
	        dataType: "json",
	        success: function(dat) {
	        	window.location.reload(true);
	        	/*
	        	$('#newpost').empty();
	        	$('#newpost').append('<div class="createPost-div"><a class="createPost" href="#">Add new link</a></div>');
	        	$('#posts').append('<a href="' + dat.post_url + '">' + dat.post_content + ' <a/><div id="inline-edit" style="display: inline-block"> | <a href="#">edit</a></div></p>');
	        	*/
	        },
	        failure: function(dat) {
	        	console.log("failed");
	        },
	    });

	});

	// AJAX event for undoing an upvote
	$(".postItem").on("click", ".un-upvote-link", function() {
		
		targetPost_id = $($(this).parent().parent()).attr('id');
		targetTopic_id = $('.topic').attr('id');
		
		$.ajax({
	        url: "unVote.rb",
	        // post this data to the server ...
	        type: "POST",
	        // grab data from the stuffInput text box
	        data: {
	        	topic_id: targetTopic_id,
	        	post_id: targetPost_id
	        },

	        // the script will also return data back to the browser, so
	        // handle it here ...
	        dataType: "json",
	        success: function(dat) {
	        	window.location.reload(true);
	        	/*
	        	$('#newpost').empty();
	        	$('#newpost').append('<div class="createPost-div"><a class="createPost" href="#">Add new link</a></div>');
	        	$('#posts').append('<a href="' + dat.post_url + '">' + dat.post_content + ' <a/><div id="inline-edit" style="display: inline-block"> | <a href="#">edit</a></div></p>');
	        	*/
	        },
	        failure: function(dat) {
	        	console.log("failed");
	        },
	    });

	});

});
