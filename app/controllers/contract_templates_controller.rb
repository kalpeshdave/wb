class ContractTemplatesController < ApplicationController
  def index
    @contracts = current_user.contracts.is_template.all
  end

end
