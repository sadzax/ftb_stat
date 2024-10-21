team1 = Team.create!(name: 'Spartak')
team2 = Team.create!(name: 'Zenit')

# Создание игроков
players = [
  { name: 'David Trezeguet', role: :forward, team: team1 },
  { name: 'Steven Gerrard', role: :midfielder, team: team1 },
  { name: 'Paolo Maldini', role: :defender, team: team1 },
  { name: 'Petr Cech', role: :goalkeeper, team: team1 },
  { name: 'Gabriel Batistuta', role: :forward, team: team2 },
  { name: 'Edgar Davids', role: :midfielder, team: team2 },
  { name: 'Alessandro Nesta', role: :defender, team: team2 },
  { name: 'Oliver Kahn', role: :goalkeeper, team: team2 }
]

players.each do |player_data|
  Player.create!(player_data)
end

# Создание матчей
match1 = Match.create!(date: '2024-04-01', home_team: team1, away_team: team2, weight: 1.0)
match2 = Match.create!(date: '2024-05-15', home_team: team2, away_team: team1, weight: 1.5)

# Добавление статистики
Statistic.create!(player: Player.find_by(name: 'Gabriel Batistuta'), match: match1, goals: 2, assists: 1, saves: 0, shots_on_target: 3)
Statistic.create!(player: Player.find_by(name: 'Steven Gerrard'), match: match1, goals: 1, assists: 2, saves: 0, shots_on_target: 4)
Statistic.create!(player: Player.find_by(name: 'Oliver Kahn'), match: match1, goals: 0, assists: 0, saves: 5, shots_on_target: 0)