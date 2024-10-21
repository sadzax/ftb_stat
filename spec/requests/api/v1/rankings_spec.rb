require 'rails_helper'

RSpec.describe "Api::V1::Rankings", type: :request do
describe "GET /api/v1/rankings" do
  let(:team1) { Team.create!(name: 'Liverpool') }
  let(:team2) { Team.create!(name: 'Manchester Unidted') }
  let!(:player1) { Player.create!(name: 'Fernando Torres', role: :forward, team: team1) }
  let!(:player2) { Player.create!(name: 'Ruud Van Nistelroy', role: :forward, team: team1) }
  let!(:match1) { Match.create!(date: '2024-04-01', home_team: team1, away_team: team2, weight: 1.0) }
  let!(:match2) { Match.create!(date: '2024-05-15', home_team: team2, away_team: team1, weight: 1.5) }

  before do
    Statistic.create!(player: player1, match: match1, goals: 2, assists: 1, saves: 0, shots_on_target: 3)
    Statistic.create!(player: player2, match: match2, goals: 1, assists: 2, saves: 0, shots_on_target: 2)
  end

  it "return top-rated player" do
    get '/api/v1/rankings', params: {
      role: 'forward',
      team: 'Liverpool',
      start_date: '2024-01-01',
      end_date: '2024-12-31',
      limit: 5
    }

    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json.length).to eq(2)
    expect(json.first['player']['name']).to eq('Fernando Torres')
  end
end
end