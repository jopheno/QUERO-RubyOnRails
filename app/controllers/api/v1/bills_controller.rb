include ActionController::HttpAuthentication::Basic::ControllerMethods

#TODO:
#Only admins can list all the billings information
#Only school managers and admins can destroy billing information in case of death of student
#Only the bank or a third party system, school managers and admins can set bills to paid status.

class Api::V1::BillsController < Api::V1::APIController
  #http_basic_authenticate_with name: "admin", password: "admin", only: [:index, :destroy]
  #http_basic_authenticate_with name: "school_manager", password: "manager", only: [:destroy]
  #http_basic_authenticate_with name: "bank", password: "knab", only: [:update]
  http_basic_authenticate_with name: "school_manager", password: "manager", only: [:index, :update, :destroy, :destroy_all]
  before_action :set_bill, only: [:show, :edit, :update, :destroy]

  # GET /bills
  def index
    #Bill.delete_all #- Just using for testing
    @bills = Bill.all
    json_response(@bills)
  end

  # GET /bills/1
  def show
    json_response(@bill)
  end

  # POST /bills
  def create
    @bill = Bill.new(bill_params_to_create)

    unless @bill.valid? then
      #logger.debug("There is errors")
      #logger.debug(@student.errors.full_messages)

      json_response(@bill.errors.full_messages, :unauthorized)
    else
      #logger.debug("There is no errors")

      @bill.save
      json_response(@bill, :created)
    end
  end

  # PATCH/PUT /bills/1
  def update
    if @bill.status == "To expire" then
      @bill.update(bill_params_to_update)
      head :no_content
    else
      json_response(["You must pay the bill that is about to expire first"], :unauthorized)
    end
  end

  # DELETE /bills/1
  def destroy
    @bill.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bill
      @bill = Bill.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def bill_params_to_update
      params.require(:bill).permit(:status)
    end
end
