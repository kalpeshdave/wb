class UserNotifier < ActionMailer::Base

  def timesheet(timesheet)
    contract = timesheet.contract
    originator = contract.creator
    
    @subject          = "Your wholebook timesheet, for the period #{timesheet.start_date} to #{timesheet.start_date}"
    @recipients       = originator.email
    @from             = 'no-reply@yourdomain.com'
    @sent_on          = Time.now
    @body["user"]     = originator
    #@body["message"]  = message.message
    @body["url"]      = timesheet_url(timesheet)
  end

  def propose_contract(message)
    @subject          = message.description
    @recipients       = message.recipient
    @from             = 'no-reply@yourdomain.com'
    @sent_on          = Time.now
    @body["user"]     = message.contract.creator
    @body["message"]  = message.message
    @body["url"]      = contract_url(message.contract)
  end

  def reject_contract(message, reason)
    @subject          = message.description
    @recipients       = message.creator.email
    @from             = 'no-reply@yourdomain.com'
    @sent_on          = Time.now
    @body["user"]     = message.creator
    @body["message"]  = reason
    @body["url"]      = contract_url(message)
  end

  def approve_contract(message, reason)
    @subject          = message.description
    @recipients       = message.creator.email
    @from             = 'no-reply@yourdomain.com'
    @sent_on          = Time.now
    @body["user"]     = message.creator
    @body["message"]  = reason
    @body["url"]      = contract_url(message)
  end

  def reject_timesheet(message, reason)
    @subject          = message.description
    @recipients       = message.creator.email
    @from             = 'no-reply@yourdomain.com'
    @sent_on          = Time.now
    @body["user"]     = message.creator
    @body["message"]  = reason
    @body["url"]      = timesheet_url(message)
  end

  def approve_timesheet(message, reason)
    @subject          = message.description
    @recipients       = message.creator.email
    @from             = 'no-reply@yourdomain.com'
    @sent_on          = Time.now
    @body["user"]     = message.creator
    @body["message"]  = reason
    @body["url"]      = timesheet_url(message)
  end

  
  
  
end
