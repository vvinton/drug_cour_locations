class JudgeInformation < ApplicationRecord
  belongs_to :program_information

  def full_name
    "#{first_name} #{last_name}"
  end
end
