$(document).ready(function() {

  $("#edit").click(function() {
    $.ajax(
      {
        url: "cgi-bin/about.rb",
        // post this data to the server ...
        type: "POST",
        // grab data from the stuffInput text box

        /*
        data: {
                stuff: $("#stuffInput").val()
              },
		*/

        // the script will also return data back to the browser, so
        // handle it here ...
        dataType: "json",
        success: function(dat) {
          console.dir(dat);
        },
      }
    );
  });

}); 