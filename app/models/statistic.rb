class Statistic < ApplicationRecord
  belongs_to :player
  belongs_to :match

  validates :goals, :assists, :saves, :shots_on_target, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
