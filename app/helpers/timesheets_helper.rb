module TimesheetsHelper

  def generate_timesheet_number(user)
    timesheet_default = user.timesheet_default
    case timesheet_default.options
    when "autonumber"
      if timesheet_default.last_timesheet_number.blank?
        number = 1
        current_timesheet_number = timesheet_default.timesheet_prefix + number.to_s
      else
        number = timesheet_number(timesheet_default)
        current_timesheet_number = timesheet_default.timesheet_prefix.blank? ? number : timesheet_default.timesheet_prefix + number.to_s
      end
    when "begindate"
      current_timesheet_number = start_date_format(timesheet_default)
    when "enddate"
      current_timesheet_number = end_date_format(timesheet_default)
    when "begin+end"
      current_timesheet_number = start_date_format(timesheet_default) + end_date_format(timesheet_default)
    when "begin+num1"
      if timesheet_default.last_timesheet_number.blank?
        number = 1
        current_timesheet_number = start_date_format(timesheet_default) + number.to_s
      else
        number = timesheet_number(timesheet_default)
        current_timesheet_number = start_date_format(timesheet_default)  + number.to_s
      end
    when "end+num2"
      if timesheet_default.last_timesheet_number.blank?
        number = 1
        current_timesheet_number = end_date_format(timesheet_default)  + number.to_s
      else
        number = timesheet_number(timesheet_default)
        current_timesheet_number = end_date_format(timesheet_default) + number.to_s
      end
    end
    current_timesheet_number.to_s
  end

  def timesheet_number(timesheet_default)
    digits = timesheet_default.last_timesheet_number.split('').map(&:to_i)
        count = 0
        digits.each_with_index do |n,i|
          count = i-1
          break if !digits[i].zero?
        end
        unless count.eql?(-1)
          number = digits[0..count].join.to_s + (digits[count..digits.count].join.to_i + 1).to_s
          if number.length > timesheet_default.last_timesheet_number.length
            number.slice!(0)
          end
        else
          number = timesheet_default.last_timesheet_number.to_i + 1
        end
        number
  end

  def start_date_format(default)
    case default.number_date_format1
    when "YYYYMM"
      Date.today.strftime('%Y%m').to_s
    when "MMYYYY"
      Date.today.strftime('%m%Y').to_s
    when "YYYYMMDD"
      Date.today.strftime('%Y%m%d').to_s
    when "YYYY"
      Date.today.strftime('%Y').to_s
    else
      Date.today.strftime('%d%m%Y').to_s
    end
  end

  def end_date_format(default)
    case default.number_date_format2
    when "YYYYMM"
      Date.today.strftime('%Y%m').to_s
    when "MMYYYY"
      Date.today.strftime('%m%Y').to_s
    when "YYYYMMDD"
      Date.today.strftime('%Y%m%d').to_s
    when "YYYY"
      Date.today.strftime('%Y').to_s
    else
      Date.today.strftime('%d%m%Y').to_s
    end
  end

  def time_base(contract)
    if contract.timesheet_default.time_base
      [[contract.timesheet_default.time_base.name, contract.timesheet_default.time_base.id], [contract.timesheet_default.time_unit.name, contract.timesheet_default.time_unit.id]]
    elsif current_user.timesheet_default.time_base
      [[current_user.timesheet_default.time_base.name, current_user.timesheet_default.time_base.id], [current_user.timesheet_default.time_unit.name, current_user.timesheet_default.time_unit.id]]
    end
  end
  
  
end
