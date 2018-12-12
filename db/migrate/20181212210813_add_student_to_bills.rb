class AddStudentToBills < ActiveRecord::Migration[5.2]
  def change
    add_reference :bills, :student, foreign_key: true
  end
end
