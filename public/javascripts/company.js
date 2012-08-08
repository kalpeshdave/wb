$(function() {
    
    $("a.wholebooks-edit-company-address").live("click", function() {
       var e = $(this);
       var addressId = e.attr("data-address-id");
       $.getJSON(e.attr('href'), function(data) {
         $("#wholebook-show-company-address-"+addressId).html(data.response);
       });
       return false;
    });

    
});