require "cpf_cnpj"

class Student < ApplicationRecord
  validate :isAValidCPFValue

  validates :cpf, presence: true, uniqueness: true

  has_one :admission, dependent: :destroy
  has_one :billing, dependent: :destroy

  def isAValidCPFValue
    unless CPF.valid?(cpf) then
      errors.add(:cpf, "- You must register a valid CPF number.")
    end
  end
end
