require 'rails_helper'

RSpec.describe Player, type: :model do
  it 'is valid with valid attributes' do
    team = Team.create!(name: 'Ajax')
    player = Player.new(name: 'Vitaly Onopko', role: :defender, team: team)
    expect(player).to be_valid
  end

  it 'is invalid without a name' do
    team = Team.create!(name: 'Ajax')
    player = Player.new(name: nil, role: :forward, team: team)
    expect(player).not_to be_valid
  end

  it 'is invalid without a role' do
    team = Team.create!(name: 'Ajax')
    player = Player.new(name: 'Vitaly Onopko', role: nil, team: team)
    expect(player).not_to be_valid
  end
end