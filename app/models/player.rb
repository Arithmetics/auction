class Player < ApplicationRecord
  has_many :games
  has_many :bids
  has_many :users, through: :bids
  has_many :drafts, through: :bids




end
