class Admission < ApplicationRecord
  belongs_to :student
  has_one_attached :document

  before_save :initialize_order

  validates :student_id, presence: true, uniqueness: true

  def initialize_order
    unless self.step? then
      self.step = "Pending"
    end
  end
end
