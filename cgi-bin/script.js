<script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
<script type="text/javascript">

$(document).ready(function() {
  console.log("Hello!");

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

</script>