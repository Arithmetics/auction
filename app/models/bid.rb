class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :draft
  belongs_to :player

  validates :amount, presence: true
  validates :user_id, presence: true
  validates :draft_id, presence: true
  validates :player_id, presence: true



end
