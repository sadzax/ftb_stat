class Match < ApplicationRecord
  belongs_to :home_team, class_name: 'Team'
  belongs_to :away_team, class_name: 'Team'
  has_many :statistics, dependent: :destroy

  validates :date, :home_team, :away_team, presence: true
end
