class SearchContractsController < ApplicationController
  before_filter :require_user
  before_filter :fetch_search_record, :only => [:new, :edit, :show, :update]

  def index
  end

  def show
    
  end

  def sent_mail
    unless params[:people].blank?
      SearchContract.deliver_mail_to_contractors!(params[:people].uniq, current_user)
      flash[:notice] = "An Email has been sent to the selected contracts!"
      redirect_to search_contracts_url
    else
      flash[:notice] = "You didn't select any contractor!"
      redirect_to search_contracts_url
    end  
  end

  def new
    unless @search_contract
      @search_contract = SearchContract.new
    else
      redirect_to edit_search_contract_url(@search_contract)
    end
  end

  def create
    @search_contract = current_user.build_search_contract(params[:search_contract])
    if @search_contract.save
      flash[:notice] = t("search_contracts.success")
      redirect_to search_contracts_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @search_contract.update_attributes(params[:search_contract])
      flash[:notice] = t("search_contracts.success_update")
      redirect_to edit_search_contract_path(@search_contract)
    else
      render :edit
    end
  end

    protected
    
    def fetch_search_record
      @search_contract = current_user.search_contract
    end
end
