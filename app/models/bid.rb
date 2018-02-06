class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :draft
  belongs_to :player



end
