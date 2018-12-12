
#Once the billing record from student is created, that means that the student is registered in the school/university as well as commited to pay the fees.
#In order to make it true, we must guarantee that it will only be accepted if his admission was approved.

#TODO: Course cost must be declared and managed, and not a const value
#TODO: Add payment method to Billing data structure or add possibility to change payment method from bills
$course_cost = 740.00

class Billing < ApplicationRecord
  validate :isAdmissionApproved
  belongs_to :student

  validates :desired_due_day, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 28 }
  validates :installments_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :student_id, presence: true, uniqueness: true

  after_update :update_bills
  after_create :generate_bills

  before_save :initialize_order

  private
    # Here we must verify if the student had his admission approved
    def isAdmissionApproved
      ad = Admission.where(student_id: student_id).first
      #ad = Admission.where("student_id = #{student_id}").order("created_on DESC").find(1)
      unless ad.step == "Approved" then
        errors.add(:student_id, "- You must be approved in order to create a billing record.")
      end
    end

    def initialize_order
      unless self.status? then
        self.status = "Pending"
      end
    end

    def update_bills
      Bill.where(student_id: student_id).each do |bill|
        #the code here is called once for each bill with the same student_id as this BillingRecord
        # bill is accessible by 'bill' variable
        if bill.status == "Open" then
          t = bill.due_date
          bill.due_date = Time.local(t.year, t.month, desired_due_day)

          bill.save
        end
      end

    end

    def generate_bills

      #Current time
      t = Time.new

      if t.day <= desired_due_day then
        logger.debug("Generating bill 1 !!!")
        b = Bill.new()
        b.value = (($course_cost)/installments_count).round(2)
        b.due_date = Time.local(t.year, t.month, desired_due_day)
        b.year = t.year
        b.month = t.month
        b.student_id = student_id
        b.status = "To expire"

        b.save

        if installments_count > 1 then
          for i in 2..installments_count
            logger.debug("Generating bill #{i} !!!")

            updated_month = ((t.month+i)-1)%13
            updated_year = t.year

            if ((t.month+i)-1) > 12 then
              updated_month = updated_month+1
              updated_year = updated_year + 1
            end

            b = Bill.new()
            b.value = (($course_cost)/installments_count).round(2)
            b.due_date = Time.local(updated_year, updated_month, desired_due_day)
            b.year = updated_year
            b.month = updated_month
            b.student_id = student_id

            b.save

          end
        end

      else
        logger.debug("Generating bill 1 !!!")
        b = Bill.new()
        b.value = (($course_cost)/installments_count).round(2)

        year = t.year
        month = (t.month+1)%13
        if (t.month+1) > 12 then
          month = month+1
          year = year+1
        end

        b.due_date = Time.local(year, month, desired_due_day)

        #Uncalled for, there is already datetime at due_date... #TODO: remove this
        b.year = year
        b.month = month
        b.student_id = student_id
        b.status = "To expire"

        b.save

        if installments_count > 1 then
          for i in 2..installments_count
            logger.debug("Generating bill #{i} !!!")

            updated_month = ((month+i)-1)%13
            updated_year = year

            if ((month+i)-1) > 12 then
              updated_month = updated_month+1
              updated_year = updated_year + 1
            end

            b = Bill.new()
            b.value = (($course_cost)/installments_count).round(2)
            b.due_date = Time.local(updated_year, updated_month, desired_due_day)
            b.year = updated_year
            b.month = updated_month
            b.student_id = student_id

            b.save
          end
        end
      end
    end
end
