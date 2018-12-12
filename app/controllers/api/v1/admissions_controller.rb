include ActionController::HttpAuthentication::Basic::ControllerMethods

#Only school managers can list all the admissions, update their state, or destroy them

#TODO: School managers should only see a list of admissions that are currently pending, while admins should see everything.

class Api::V1::AdmissionsController < Api::V1::APIController
  #http_basic_authenticate_with name: "admin", password: "admin", only: [:index, :update, :destroy]
  http_basic_authenticate_with name: "school_manager", password: "manager", only: [:index, :update, :destroy]
  before_action :set_admission, only: [:show, :edit, :update, :destroy]

  # GET /admissions
  def index
    @admissions = Admission.all
    json_response(@admissions)
  end

  # GET /admissions/1
  def show
    json_response(@admission)
  end

  # POST /admissions
  def create
    @admission = Admission.new(admission_params)

    unless @admission.valid? then
      #logger.debug("There is errors")
      #logger.debug(@student.errors.full_messages)

      json_response(@admission.errors.full_messages, :unauthorized)
    else
      #logger.debug("There is no errors")

      @admission.save
      json_response(@admission, :created)
    end
  end

  # PATCH/PUT /admissions/1
  def update
    @admission.update(admission_params_from_manager)
    head :no_content
  end

  # DELETE /admissions/1
  def destroy
    @admission.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admission
      @admission = Admission.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def admission_params
      params.require(:admission).permit(:student_id, :enem_grade)
    end

    def admission_params_from_manager
      params.require(:admission).permit(:enem_grade, :step)
    end
end
