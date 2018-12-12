include ActionController::HttpAuthentication::Basic::ControllerMethods

#TODO:
#Only admins can list all the billings information
#Only school managers and admins can destroy billing information in case of death of student

class Api::V1::BillingsController < Api::V1::APIController
  #http_basic_authenticate_with name: "admin", password: "admin", only: [:index, :destroy]
  #http_basic_authenticate_with name: "school_manager", password: "manager", only: [:destroy]
  http_basic_authenticate_with name: "school_manager", password: "manager", only: [:index, :destroy]
  before_action :set_billing, only: [:show, :edit, :update, :destroy]

  # GET /billings
  def index
    @billings = Billing.all
    json_response(@billings)
  end

  # GET /billings/1
  def show
    json_response(@billing)
  end

  # POST /billings
  def create
    @billing = Billing.new(billing_params_to_create)

    unless @billing.valid? then
      #logger.debug("There is errors")
      #logger.debug(@student.errors.full_messages)

      json_response(@billing.errors.full_messages, :unauthorized)
    else
      #logger.debug("There is no errors")

      @billing.save
      json_response(@billing, :created)
    end
  end

  # PATCH/PUT /billings/1
  def update
    @billing.update(billing_params_to_update)
    head :no_content
  end

  # DELETE /billings/1
  def destroy
    @billing.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_billing
      @billing = Billing.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def billing_params_to_create
      params.require(:billing).permit(:student_id, :desired_due_day, :installments_count)
    end

    def billing_params_to_update
      params.require(:billing).permit(:desired_due_day)
    end
end
