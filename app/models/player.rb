class Player < ApplicationRecord
  belongs_to :team
  has_many :statistics, dependent: :destroy

  # при наличии доп.времени я изолировал бы для каждой позиции отдельную модель в консёрны 
  # и не использовал бы енумератор
  enum role: { goalkeeper: 0, defender: 1, midfielder: 2, forward: 3 }

  validates :name, :role, presence: true
end