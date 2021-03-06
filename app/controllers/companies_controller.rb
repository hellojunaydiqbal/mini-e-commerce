class CompaniesController < ApplicationController

  before_action :set_company, only: %i[ show edit update destroy]
  before_action :authenticate_user!, :except => [:list]
  #before_action :authenticate_customer!
  
  
  load_and_authorize_resource


  def index
    
    if current_user.has_role?(:vendor)
      @company = Company.where(user_id: current_user.id)
    elsif current_user.has_role?(:employee)
      @company = Company.where(user_id: current_user.invited_by_id)
    else
      redirect_to new_company_path
    end
    
  end

  def list
    if customer_signed_in? || user_signed_in?
      @company = Company.all.order("created_at DESC")
    else
      respond_to do |format|
        format.html { redirect_to new_company_path, notice: "You've not owned any company!" }
        format.json { render :show, status: :created, location: @company }
      end
    end

  end

  def employee
    if current_user.has_role?(:employee)
      @who_invited_me = User.find(current_user.invited_by_id)
    end
  end

  def show
    #authorize! :show, @company
  end

  def new
    #authorize! :show, @company
    @company = Company.new
    
  end

  def create
    @company = Company.new(company_params)
    @company.user_id = current_user.id
    respond_to do |format|
      if @company.save
        format.html { redirect_to companies_path, notice: "Company was successfully created." }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    #authorize! :update, @company
  end

  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: "Company was successfully updated." }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: "Company was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      params.require(:company).permit(:name, :description, :user_id)
    end

end
