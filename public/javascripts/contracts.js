$(function() {

    $("#user_contract_default_attributes_allow_timesheet").live('click', function() {
      var e = $(this);
      if (e.is(":checked") == false) {
        $("#user_contract_default_attributes_require_timesheet_signature").attr('checked', false);
      }
    });
    
    $("#user_contract_default_attributes_allow_expenses").live('click', function() {
      var e = $(this);
      if (e.is(":checked") == false) {
        $("#user_contract_default_attributes_require_expense_approval").attr('checked', false);
      }
    });

    $("#contract__is_template").live("click", function(){
        var e = $(this);
        var href  = e.attr("data-href");
        if (e.is(":checked") == true) {
        $.getJSON(href, {
            "is_template" : true
            }, function(response) {
                alert("Updated Successfully .......");
        });
        }
        else {
            $.getJSON(href, {
            "is_template" : false
            }, function(response) {
                alert("Updated Successfully .......");
           });
        }

    });
    
    $("#contract_start_date, #contract_end_date").datepicker();

    //  $("#contract_description").live("keyup", function() {
    //    var e = $(this);
    //    e.val(e.val().toUpperCase());
    //    //
    //  });

    $("#user_timesheet_default_attributes_time_base_id, #contract_timesheet_default_attributes_time_base_id").live("change", function(){
        var e  = $(this);
        var href  = e.attr("data-href");
        if(e.val() != ""){
           $.getJSON(href, {
            "time_base_id" : e.val()
            }, function(response) {
            $("#time_units").html(response.get_time_units_page);
        });
        }
    });
    
    $(".timesheet_expenses").live("click", function() {
        var e = $(this);
        if (e.is(':checked')) {
            $("#user_contract_default_attributes_require_"+e.attr("data-name")).attr("readonly", false);
            $("."+e.attr("data-name")).css("display", "block");
        } else {
            $("#user_contract_default_attributes_require_"+e.attr("data-name")).attr("readonly", true);
            $("."+e.attr("data-name")).css("display", "none");
        }
    });

    $("#contract_recepient_company_id").live("change", function() {
        var e  = $(this);
        var href  = e.attr("data-href");
           $.getJSON(href, {
            "recepient_company_id" : e.val()
            }, function(response) {
            $(".recipients").html(response.get_recipients_page);
        });       
    });
    
    $("#contract_client_company_id-test").live("change", function() {
        var e  = $(this);
        var href  = e.attr("data-href");
        if(e.val() == -1){
            $("#recepient_client_company").css("display", "block");
        }else{
            $.getJSON(href, {
            "client_company_id" : e.val()
            }, function(response) {
            $("#clients").html(response.get_clients_page);
        });
        $("#recepient_client_company").css("display", "none");
        }
           
    });


    $("#contract_client_id").live("change", function() {
        var e  = $(this);
        if(e.val() == -1){
          $("#recepient_client_contact").css("display", "block");
        } else {
             $("#recepient_client_contact").css("display", "none");
        }
    });
    
    $("#contract_is_recipient").live("click", function() {
      var e     = $(this);
      var url   = e.attr("data-href");
      var checkedUnchecked = e.is(":checked");
      $.getJSON(url, {'checked':checkedUnchecked}, function(response) {
        $("#wholebooks-client-detail").html(response.data);
      });
    });

    $("#contract_client_company_id").live('change', function() {
      var e = $(this);
      console.log(e);
    });

    if ($('#contract_is_recipient').attr('checked')) {
        $("#normal_contract, .post, .propose").css("display", "none");
        $("#recepient_contract").css("display", "block");
    } else {
        $("#recepient_contract").css("display", "none");
        $("#normal_contract, .post, .propose").css("display", "block");
    }

    $("#user_contract_default_attributes_auto_number").live("change", function(){
        var e = $(this);
        if (e.is(':checked')) {
            $("#user_contract_default_attributes_last_contract_number").attr('disabled', false);
        }
        else {
            $("#user_contract_default_attributes_last_contract_number").attr('disabled', true);
        }
    });

   
    
  

});