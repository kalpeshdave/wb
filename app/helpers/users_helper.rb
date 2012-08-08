module UsersHelper
  
  def init_user(user)
    returning(user) do |u|
      u.build_primary_address if u.primary_address.blank?
    end
  end

  def fields_for_task(field_name, attribute_name, &block)
    prefix = field_name.new_record? ? 'new' : 'existing'
    if params[:controller] == "users"
      fields_for("user[#{prefix}_#{attribute_name}_attributes][]", field_name, &block)
    else
      if params[:controller] == "search_contractors"
        fields_for("search_contractor[#{prefix}_#{attribute_name}_attributes][]", field_name, &block)
      else
        if params[:controller] == "search_contracts"
          fields_for("search_contract[#{prefix}_#{attribute_name}_attributes][]", field_name, &block)
        else
          if params[:controller] == "timesheets"
            fields_for("timesheet[#{prefix}_#{attribute_name}_attributes][]", field_name, &block)
          else
            if params[:controller] == "companies"
              #fields_for("company[#{prefix}_#{attribute_name}_attributes][]", field_name, &block)
              fields_for("company[#{attribute_name}_attributes][]", field_name, &block)
            else
              fields_for("contract[#{prefix}_#{attribute_name}_attributes][]", field_name, &block)
            end
          end
        end
      end
    end    
  end

  def get_user_list
    
  end

end
