#Which bill has a unique code that must be associated to a student, so to do that we must execute:
# rails g migration addStudentToBills student:references

class CreateBills < ActiveRecord::Migration[5.2]
  def change
    create_table :bills do |t|
      t.numeric   :value
      t.datetime  :due_date
      t.datetime  :paid_date
      t.string    :status
      t.string    :payment_method
      t.integer   :month
      t.integer   :year

      t.timestamps
    end
  end
end
