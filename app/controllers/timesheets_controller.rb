require 'pdf/writer'
require 'pdf/simpletable'

class TimesheetsController < ApplicationController
  before_filter :require_user
  before_filter :find_timesheet, :only => [:edit, :update, :show, :pdf, :gen_pdf, :approve_reject, :recepient_reason]
  before_filter :check_status, :only => [:edit]

  def index
    unless params[:status].blank?
      if params[:status] == "weekly_rec_timesheet" or params[:status] == "monthly_rec_timesheet"
        @timesheets = current_user.send(params[:status]).paginate(:page => params[:page], :per_page => Contract::PER_PAGE)
      else
        @timesheets = current_user.timesheets.send(params[:status]).paginate(:page => params[:page], :per_page => Timesheet::PER_PAGE)
      end
    else
      @timesheets = current_user.timesheets.all + current_user.monthly_rec_timesheet
      @timesheets = @timesheets.paginate(:page => params[:page], :per_page => Timesheet::PER_PAGE)
    end
  end

  def new
      @contracts  = Contract.recepient_contracts(current_user.id)
      @timesheet  = Timesheet.new
  end

  def create
    @contracts  = Contract.recepient_contracts(current_user.id)
    params[:timesheet].merge!(:post_type => params[:commit])
    @timesheet = current_user.timesheets.build(params[:timesheet])
    
    Timesheet.transaction do
      if @timesheet.save
        if @timesheet.status.eql?("submitted")
          @timesheet.deliver_timesheet!
          flash[:notice] = t("timesheets.submit_success")
          redirect_to timesheet_path(@timesheet)
        else
          flash[:notice] = t("timesheets.success")
          redirect_to edit_timesheet_path(@timesheet)
        end
      else
        render :action => 'new'
      end
    end
  end

  def edit
    @contracts  = Contract.recepient_contracts(current_user.id)
  end

  def show; end

  def update
    @contracts  = Contract.recepient_contracts(current_user.id)
    params[:timesheet].merge!(:post_type => params[:commit])
    if @timesheet.update_attributes(params[:timesheet])
      flash[:notice] = t("timesheets.update_success")
      redirect_to edit_timesheet_path(@timesheet)
    else
      render :edit
    end
  end

  def pdf
    _p = gen_pdf
    send_data _p.render, :filename => @timesheet.timesheet_number+".pdf", :type => "application/pdf"
  end

  def get_time_units
     unless params[:time_base_id].nil?
      @time_base = TimeBase.find(params[:time_base_id])
      case params[:time_base_id]
      when "1"
        @time_units = TimeUnit.find(:all, :limit => 3)
      when "2"
        @time_units = TimeUnit.find(:all, :limit => 4)
      when "3"
        @time_units = TimeUnit.find(:all, :limit => 5)
      else
        @time_units = TimeUnit.find(:all)
      end
      json = { :get_time_units_page => render_to_string(:partial => "time_units", :object => @time_units) }
      render :json => json
     end
  end

  def fetch_contract_values
     unless params[:contract_id].blank?
       @contract = Contract.find(params[:contract_id])
       json = { :fetch_contract_values_page => render_to_string(:partial => "after_contract_select", :object =>  {:contract => @contract}), :fetch_contract_timeunits_page => render_to_string(:partial => "unit_after_select", :object =>  {:contract => @contract}) }
       render :json => json
     else
       json = { :fetch_contract_values_page => render_to_string(:partial => "before_contract_select"), :fetch_contract_timeunits_page => render_to_string(:partial => "unit_before_select") }
       render :json => json
     end
  end

  def recepient_reason
    render
  end
  
   def approve_reject
    if params[:commit].eql?("Reject")
      @timesheet.rejected!
      UserNotifier.deliver_reject_timesheet(@timesheet, params[:reason])
      flash[:notice] = "Timesheet has been Rejected"
      redirect_to timesheet_dashboard_path
    else
      @timesheet.approved!
      UserNotifier.deliver_approve_timesheet(@timesheet, params[:reason])
      flash[:notice] = "Timesheet has been Accepted"
      redirect_to timesheet_dashboard_path
    end
  end


  private

  def find_timesheet
    @timesheet = current_user.find_time_sheet(params[:id])#current_user.timesheets.find(params[:id])
    unless @timesheet
      redirect_to timesheet_dashboard_path
    end
  end

  def check_status
    redirect_to timesheet_url(@timesheet) if @timesheet.status.eql?("submitted") || @timesheet.status.eql?("approved")
  end

  def gen_pdf
    _p = PDF::Writer.new
    _p.select_font 'Times-Roman'
    _p.text "Wholebooks", :font_size => 62, :justification => :center
    _p.text "<Client Company>", :font_size => 18, :justification => :left
#    _p.text "Contract: #{@timesheet.contract.contract_number} #{@timesheet.contract.description}", :font_size => 18, :justification => :left
    _p.text "Begin Date: #{@timesheet.start_date}", :font_size => 18, :justification => :left
    _p.text "End Date: #{@timesheet.end_date}", :font_size => 18, :justification => :right
    _p.text "", :font_size => 22, :justification => :center
    table = PDF::SimpleTable.new
    table.title = "Months"
    table.column_order.push(*%w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday))

    table.columns["Sunday"] = PDF::SimpleTable::Column.new("sunday")
    table.columns["Sunday"].width = 80
    table.columns["Sunday"].heading = "Sunday"

    table.columns["Monday"] = PDF::SimpleTable::Column.new("monday")
    table.columns["Monday"].width = 80
    table.columns["Monday"].heading = "Monday"

    table.columns["Tuesday"] = PDF::SimpleTable::Column.new("tuesday")
    table.columns["Tuesday"].width = 80
    table.columns["Tuesday"].heading = "Tuesday"

    table.columns["Wednesday"] = PDF::SimpleTable::Column.new("wednesday")
    table.columns["Wednesday"].width = 80
    table.columns["Wednesday"].heading = "Wednesday"

    table.columns["Thursday"] = PDF::SimpleTable::Column.new("thursday")
    table.columns["Thursday"].width = 80
    table.columns["Thursday"].heading = "Thursday"

    table.columns["Friday"] = PDF::SimpleTable::Column.new("friday")
    table.columns["Friday"].width = 80
    table.columns["Friday"].heading = "Friday"

    table.columns["Saturday"] = PDF::SimpleTable::Column.new("saturday")
    table.columns["Saturday"].width = 80
    table.columns["Saturday"].heading = "Saturday"

    table.show_lines    = :all
    table.show_headings = true
    table.font_size = 12
    table.position    = 50
    table.orientation = :right
    table.width       = 550

    data = [
      {"sunday"=> "", "monday"=> "", "tuesday"=> "", "wednesday"=> "", "thursday"=> "", "friday"=> "", "saturday"=> ""},
      {"sunday"=> "", "monday"=> "", "tuesday"=> "", "wednesday"=> "", "thursday"=> "", "friday"=> "", "saturday"=> ""},
      {"sunday"=> "", "monday"=> "", "tuesday"=> "", "wednesday"=> "", "thursday"=> "", "friday"=> "", "saturday"=> ""},
      {"sunday"=> "", "monday"=> "", "tuesday"=> "", "wednesday"=> "", "thursday"=> "", "friday"=> "", "saturday"=> ""},
      {"sunday"=> "", "monday"=> "", "tuesday"=> "", "wednesday"=> "", "thursday"=> "", "friday"=> "", "saturday"=> ""},
    ]

    table.data.replace data
    table.render_on(_p)
    _p.text "Total <Time Unit>: <Total Time>", :font_size => 18, :justification => :right
    _p.line(30, 520, 260, 520)
    _p.text "Client Signature", :font_size => 18, :justification => :left
    _p.text "Recipient Signature", :font_size => 18, :justification => :right
    _p.line(30, 475, 260, 475)
    _p.text "Date", :font_size => 18, :justification => :left
    _p.text "Date", :font_size => 18, :justification => :right

    _p
  end
end
