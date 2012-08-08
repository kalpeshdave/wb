module ContractsHelper
  def collection_for_companies
    result = Company.all.map { |i| [i.name, i.id] }
    result << ["Other", -1]
  end

  def collection_for_users
    result = User.all.map { |i| [i.name, i.id] }
    result << ["Other", -1]
  end

  def collection_for_selected_users
     result = @users.collect {|i| [i.name, i.id]}
  end

  def generate_contract_number(user)
    contract_default = ContractDefault.find_by_user_id(user)
    if contract_default.auto_number?
      if contract_default.last_contract_number.blank?
        number = 1
        current_contract_number = contract_default.contract_prefix + number.to_s
      else
        number = contract_number(contract_default)
        current_contract_number = contract_default.contract_prefix.blank? ? number.to_s : contract_default.contract_prefix + number.to_s
      end
    else
      current_contract_number = contract_default.contract_prefix.blank? ? "" : contract_default.contract_prefix
    end
    current_contract_number.to_s
  end

  def contract_number(contract_default)
    digits = contract_default.last_contract_number.split('').map(&:to_i)
        count = 0
        digits.each_with_index do |n,i|
          count = i-1
          break if !digits[i].zero?
        end
        unless count.eql?(-1)
          number = digits[0..count].join.to_s + (digits[count..digits.count].join.to_i + 1).to_s
          if number.length > contract_default.last_contract_number.length
            number.slice!(0)
          end
        else
          number = contract_default.last_contract_number.to_i + 1
        end
        number
  end

  def time_units(id)
    case id
      when 1
        time_units = TimeUnit.find(:all, :limit => 3)
      when 2
        time_units = TimeUnit.find(:all, :limit => 4)
      when 3
        time_units = TimeUnit.find(:all, :limit => 5)
      else
        time_units = TimeUnit.find(:all)
      end
      result = []
        time_units.each do |tu|
          result << [tu.name, tu.id]
        end
    result
  end
end
