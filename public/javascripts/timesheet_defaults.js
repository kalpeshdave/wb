$(function() {
    $("#user_timesheet_default_attributes_options").live("change", function(){
        var e  = $(this);
        $(".number").css("display", "block");
        switch (e.val()) {
                    case ('autonumber'):
                        $(".prefix").css("display", "block");
                        $(".num1, .num2, .concat").css("display", "none");
                        $("#user_timesheet_default_attributes_last_timesheet_number").attr("readonly", false);
                        break;
                    case ('begindate'):
                        $(".num1").css("display", "block");
                        $(".num2, .concat, .prefix").css("display", "none");
                        $("#user_timesheet_default_attributes_last_timesheet_number").attr("readonly", true);
                        break;
                    case ('enddate'):
                         $(".num1, .concat, .prefix").css("display", "none");
                         $(".num2").css("display", "block");
                         $("#user_timesheet_default_attributes_last_timesheet_number").attr("readonly", true);
                        break;
                    case ('begin+end'):
                        $(".num1, .num2, .concat").css("display", "block");
                        $(".prefix").css("display", "none");
                        $("#user_timesheet_default_attributes_last_timesheet_number").attr("readonly", true);
                        break;
                    case ('begin+num1'):
                        $(".num1").css("display", "block");
                        $(".num2, .concat, .prefix").css("display", "none");
                        $("#user_timesheet_default_attributes_last_timesheet_number").attr("readonly", false);
                        break;
                    case ('end+num2'):
                        $(".num1, .concat, .prefix").css("display", "none");
                         $(".num2").css("display", "block");
                         $("#user_timesheet_default_attributes_last_timesheet_number").attr("readonly", false);
                        break;
                }
    });    
});