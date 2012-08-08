class SearchContractorsController < ApplicationController
  before_filter :require_user
  before_filter :fetch_search_record, :only => [:new, :edit, :show, :update]
  
  def show
    
  end

  def sent_mail
    unless params[:people].blank?
      SearchContractor.deliver_mail_to_contractors!(params[:people].uniq, current_user)
      flash[:notice] = "An Email has been sent to the selected contractors!"
      redirect_to search_contracts_url
    else
      flash[:notice] = "You didn't select any contractor!"
      redirect_to search_contracts_url
    end
  end
  
  def new
    unless @search_contractor
      @search_contractor = SearchContractor.new
    else
      redirect_to edit_search_contractor_url(@search_contractor)
    end
  end

  def create
    @search_contractor = current_user.build_search_contractor(params[:search_contractor])
    if @search_contractor.save
      flash[:notice] = t("search_contractors.success")
      redirect_to search_contracts_url
    else
      render :new
    end
  end

  def edit
    
  end

  def update
    if @search_contractor.update_attributes(params[:search_contractor])
      flash[:notice] = t("search_contractors.success_update")
      redirect_to edit_search_contractor_path
    else
      render :edit
    end
  end

  protected

    def fetch_search_record
      @search_contractor = current_user.search_contractor
    end
end
