#TODO: Manage payments
#TODO: Catch exceptions when more than one payment is made to a unique bill

class Bill < ApplicationRecord
  #has_many :payments

  before_save :initialize_order

  validates :student_id, presence: true
  validates :value, presence: true, numericality: { greater_than: 0 }
  validates :year, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :month, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :status, presence: true

  before_update :update_bills

  private

    def initialize_order
      unless self.status? then
        self.status = "Open"
      end

      unless self.payment_method? then
        self.payment_method = "Ticket"
      end
    end

    def update_bills

      if self.status == "Paid" then
        #Current time
        self.paid_date = Time.new
      end

      #TODO: Once it's not able to search into Bill data over here (inside the declaration of Bill class), it will need to solve this issue another way
      #One possible solution is to create a cron job that will set the next bill to the state "To expire".

    end
end

=begin
next_bill = False

Bill.where(student_id: student_id).each do |bill|
  #the code here is called once for each bill with the same student_id as this BillingRecord
  # bill is accessible by 'bill' variable
  if bill.status == "Paid" then
    #Current time
    bill.paid_date = Time.new
    next_bill = True

    bill.save
  end

  if next_bill == True then
    bill.status = "To expire"
    next_bill = False

    bill.save
  end
end

if next_bill == True then
  #TODO: All the bills was successfully paid, we must change billing status to Paid
  logger.debug(">> TODO: All the bills was successfully paid, we must change billing status to Paid")
end
=end
