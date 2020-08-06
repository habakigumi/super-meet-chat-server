class Room < ApplicationRecord
  has_many :messages

  def to_param
    key
  end
end
