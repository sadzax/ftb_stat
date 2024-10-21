require 'rails_helper'

RSpec.describe "Api::V1::Statistics", type: :request do
describe "POST /api/v1/statistics" do
  let(:team) { Team.create!(name: 'Ajax') }
  let(:player) { Player.create!(name: 'Leo Messi', role: :forward, team: team) }
  let(:match) { Match.create!(date: '2024-06-01', home_team: team, away_team: team, weight: 1.0) }

  it "creates new stats" do
    post '/api/v1/statistics', params: {
      statistic: {
        player_id: player.id,
        match_id: match.id,
        goals: 1,
        assists: 2,
        saves: 0,
        shots_on_target: 3
      }
    }

    expect(response).to have_http_status(:created) # 201 ?
    expect(JSON.parse(response.body)['message']).to eq('Статистика добавлена успешно')
    expect(Statistic.last.goals).to eq(1)
  end

  it "returns error on stats" do
    post '/api/v1/statistics', params: {
      statistic: {
        player_id: nil,
        match_id: match.id,
        goals: -1,
        assists: 2,
        saves: 0,
        shots_on_target: 3
      }
    }

    expect(response).to have_http_status(:unprocessable_entity)
  end
end
end