class Draft < ApplicationRecord
  has_many :bids
  has_many :players, through: :bids
  has_many :users, through: :bids

end
