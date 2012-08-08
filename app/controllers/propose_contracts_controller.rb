class ProposeContractsController < ApplicationController
  before_filter :require_user
  before_filter :find_contract
  
  def new
    @propose_contract = @contract.build_propose_contract
  end

  def create
    
    @propose_contract = @contract.build_propose_contract(params[:propose_contract])
    if @propose_contract.save
      @contract.propose!
      flash[:notice] = "Your Contract Has Been Proposed"
      redirect_to edit_contract_path(@contract)
    else
      render :action => "new"
    end
    
  end

  private

  def find_contract
    @contract = Contract.find(params[:contract_id])
  end

end
