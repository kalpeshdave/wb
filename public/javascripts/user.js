
$(function() {

    $("a#wholebooks-add-user-access-list").live('click', function() {
       var e = $(this);
       $.getJSON(e.attr('href'), function(data) {
          console.log(data.response);
          $("#user_access_lists").prepend(data.response);
       });
       return false;
    });

    $("#wholebooks-user-address-edit").live('click', function() {
      var e = $(this);
      var divClass = e.attr('class');
      var addressId = e.attr('data-address');
      $.getJSON(e.attr('href'), function(response) {
        $("#"+divClass).hide();
        console.log($("#wholebook-edit-address-"+addressId));
        $("#wholebook-edit-address-"+addressId).show();
        $("#wholebook-edit-address-"+addressId).slideDown('slow', function() {
           $(this).html(response.data);
        });
      });
      return false;
    });

    $("#wholebooks-cancel-address").live('click', function() {
       $(".wholebook-add-address-div").slideUp('slow');
       return false;
    });

    $(".wholebooks-add-address-link").live('click', function() {
        var e = $(this);
        $.getJSON(e.attr('href'), function(response) {
            $("#wholebooks-add-address").html(response.data).slideDown('slow');
        });
        return false;
    });
    
    
    $("#user_user_preference_attributes_contact_me").live("click", function(event) {
        var e     = $(this);
        var value = e.is(':checked') ? "Block User" : "Allow User";
        var href  = e.attr("data-href");
        //$(".wholebook-block-allow-user").html(value);
        $.getJSON(href, {
            "contact_me": e.is(':checked')
        }, function(response) {
            $("#user_access_list").html(response.user_access_page);
        });

        var list = e.is(':checked') ? "Allow User" : "Block User" ;
        alert("Successfully removed all "+list);
        $(".user_access_list").detach();
        
    });

    $(".mailing").live("click", function(){
        $(".mailing_div").toggle();
    });

    $(".billing").live("click", function(){
        $(".billing_div").toggle();
    });

    $("a.wholebooks-edit-user-address").live("click", function() {
       var e = $(this);
       var addressId = e.attr("data-address-id");
       $.getJSON(e.attr('href'), function(data) {
         $("#wholebook-show-user-address-"+addressId).html(data.response);
       });
       return false;
    });
   
});

function okCancelConfirm(msg)
{
    var answer = confirm (msg)
    if (answer)
    {
        return true; // submit page
    }
    else
    {
        return false; // cancel page submission
    }
}






