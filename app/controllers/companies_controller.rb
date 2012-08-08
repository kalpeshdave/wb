class CompaniesController < ApplicationController
  before_filter :require_user, :only => [:index, :create, :use, :change]
  before_filter :find_company, :only => [:edit, :update, :edit_address, :update_address]

  def index
    @users_companies = current_user.company_users
    if @users_companies
      @user_companies = []
      @users_companies.each do |uc|
        company = Company.find(uc.company_id)
        if @user_companies.include?(company)
          next
        else
          @user_companies << company
        end
      end
      @companies = Company.all - @user_companies
    else
      @companies = Company.all
    end
  end

  def new
    @company = Company.new
  end

  def show
    @company = Company.find(params[:id])
  end

  def change
    @company = Company.find(params[:id])
  end

  def edit; end

  def edit_address
    @address = @company.addresses.find(params[:address_id])
    json = { :response => render_to_string(:partial => "edit_address") }
    render :json => json
  end

  def update_address
    @address = @company.addresses.find(params[:address_id])
    if @address.update_attributes(params[:address])
      json = { :response => render_to_string(:partial => "show_address") }
      render :json => json
    end
  end

  def create
    @company = current_user.companies.build(params[:company])
    if @company.save
      flash[:notice] = t("companies.success")
      redirect_to companies_url
    else
      render :action => 'new'
    end
  end

  def use
    @company = Company.find(params[:id])
    @company_user = CompanyUser.find_by_user_id(current_user.id)
    if @company_user
      @company_user.destroy
    end
    @company.use(current_user)
    redirect_to account_url
  end

  def update
    if @company.update_attributes(params[:company])
      flash[:notice] = t("companies.success_update")
      redirect_to edit_company_url(@company)
    else
      render :action => :edit
    end
  end

  def delete_address
    @company = Company.find(params[:company_id])
    @address = Address.find(params[:id])
    @address.destroy
    redirect_to edit_company_path(@company)
  end

  private

  def fetch_user_company
    @company = current_user.company_user.company
  end

  def find_company
    @company = current_user.companies.find(params[:id])
    if @company.blank?
      redirect_to root_path and return
    end
  end
end
