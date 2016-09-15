# == Schema Information
#
# Table name: provinces
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  timezone   :string           not null
#

class Province < ActiveRecord::Base
  has_paper_trail

  # Associations
  has_many :user

  # Display methods
  def to_s
    name
  end
end
