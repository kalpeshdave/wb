$(function() {
     jQuery.datepicker.formatDate({dateFormat: 'yy/mm/dd' });

    $("#timesheet_start_date").datepicker();

    $("#user_timesheet_default_attributes_time_base_id, #timesheet_time_base_id").live("change", function(){
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

    $("#timesheet_contract_id").live("change", function(){
        var e  = $(this);
        var href  = e.attr("data-href");
           $.getJSON(href, {
            "contract_id" : e.val()
            }, function(response) {
            $("#wholebooks-timesheet-create").html(response.fetch_contract_values_page);
            $("#time_units").html(response.fetch_contract_timeunits_page);
        });
    });
});

$(document).ready(function(){
      // page is now ready, initialize the calendar...
      
        createcalendar("month")

        $("#timesheet_time_base_id").live("change", function(){
            var e  = $(this);
            var start_date = $("#timesheet_start_date").val()
            change_date(e.val(), start_date)
            changecalendarview(e.val())
        });

        $("#timesheet_start_date").live("change", function(){
            var e  = $(this);
            var time_base = $("#timesheet_time_base_id").val()
            change_date(time_base, e.val())
        });  
  });

  function createcalendar(value)
  {
    $('#calendar').fullCalendar({
          editable: true,
          header: {
              left: '',
              center: '',
              right: ''
          },
          defaultView: value,
          height: 300,
          slotMinutes: 15,
          loading: function(bool){
              if (bool)
                  $('#loading').show();
              else
                  $('#loading').hide();
          }
    });
  }

  function change_date(tb, date)
  {
            var d = new Date(date);
            var curr_date = d.getDate();
            var curr_month = d.getMonth();
            var curr_year = d.getFullYear();

            switch (tb) {
                    case ('1'):
                        var end_date = new Date(curr_year, curr_month, curr_date+1);
                        $("#timesheet_end_date").val(end_date);
                        break;
                    case ('2'):
                        var end_date = new Date(curr_year, curr_month, curr_date+7);
                        $("#timesheet_end_date").val(end_date);
                        break;
                    case ('3'):
                        var end_date = new Date(curr_year, curr_month, curr_date+30);
                        $("#timesheet_end_date").val(end_date);
                        break;
                    case ('4'):
                        var end_date = new Date(curr_year, curr_month, curr_date+365);
                        $("#timesheet_end_date").val(end_date);
                        break;
                }
  }

  function changecalendarview(tb){
      switch (tb) {
                    case ('1'):
                        $('#calendar').fullCalendar('changeView', "agendaDay");
                        break;
                    case ('2'):
                        $('#calendar').fullCalendar('changeView', "agendaWeek");
                        break;
                    case ('3'):
                        $('#calendar').fullCalendar('changeView', "month");
                        break;
                    case ('4'):
                        alert("No Option Defined For Year!!")
                        $('#calendar').fullCalendar('changeView', "month");
                        break;
                }
  }