module Api
  module V1
    class RankingsController < ApplicationController
      def index
        role = params[:role]
        team = params[:team]
        start_date = params[:start_date]
        end_date = params[:end_date]
        limit = params[:limit] || 5
        page = params[:page] || 1
        per_page = params[:per_page] || 5
      
        # ищем в кэше, если там не будет, то в сайдкике закешируемся
        cache_key = "rankings/#{role}/#{team}/#{start_date}/#{end_date}/#{limit}/#{page}/#{per_page}"
        cached_result = Rails.cache.read(cache_key)

        if cached_result
          render json: cached_result
        else
          RankingWorker.perform_async(role, team, start_date, end_date, limit, page, per_page)
          render json: { message: 'Запущен расчёт рейтинга. Зайдите позже за результатами' }, status: :accepted
        end
        # в задании предполагается настроить и асинхронные операции и кеширование, потенциально есть узкое место при такой реализации
        # например, если пользователь запросил рейтинг, ушёл сигнал на расчёт и сохранение в кеш, но если
        # пользователь повторно придёт с тем же запросом до исполнения запроса сайдкика, то запустится ещё один процесс расчёта
        # это и лишняя нагрузка и потенциальный конфликт записи по одному кеш-ключу
      end

      private

      def calculate_rating(player, start_date, end_date)  
        # для синхронного расчёта - не используется сейчас
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
  end
end