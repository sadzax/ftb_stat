class RankingWorker
  include Sidekiq::Worker

  def perform(role, team, start_date, end_date, limit, page, per_page)
    players = Player.includes(:statistics).where(role: role)
    players = players.joins(:team).where(teams: { name: team }) if team.present?
    players = players.joins(:statistics => :match).where(matches: { date: start_date..end_date }) if start_date.present? && end_date.present?

    ranked_players = players.map do |player|
      {
        player: player,
        rating: calculate_rating(player, start_date, end_date)
      }
    end

    ranked_players = ranked_players.sort_by { |p| -p[:rating] }
                                 .paginate(page: page, per_page: per_page)

    result = ranked_players.to_json

    # сюда можно прийти только при отсутствии кешированного ответа, поэтому кешируемся в конце
    cache_key = "rankings/#{role}/#{team}/#{start_date}/#{end_date}/#{limit}/#{page}/#{per_page}"
    Rails.cache.write(cache_key, result, expires_in: 12.hours)
  end

  private

  def calculate_rating(player, start_date, end_date)
    statistics = player.statistics.joins(:match).where(matches: { date: start_date..end_date })

    total_rating = 0.0

    statistics.each do |stat|
      weight = stat.match.weight
      # при наличии доп.времени я изолировал бы для каждой позиции логику в отдельный класс
      role_rating = case player.role
                    when 'goalkeeper'
                      stat.saves * 3 + stat.goals * 1 + stat.assists * 1
                    when 'defender'
                      stat.goals * 3 + stat.assists * 2 + stat.shots_on_target * 1
                    when 'midfielder'
                      stat.goals * 2 + stat.assists * 3 + stat.shots_on_target * 1
                    when 'forward'
                      stat.goals * 3 + stat.assists * 2 + stat.shots_on_target * 1
                    else
                      0
                    end
      total_rating += role_rating * weight
    end

    total_rating
  end
end
