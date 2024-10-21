module Api
  module V1
    class StatisticsController < ApplicationController
      # только POST
      def create
        statistic = Statistic.new(statistic_params)
        if statistic.save
          render json: { message: 'Статистика добавлена успешно' }, status: :created
        else
          render json: { errors: statistic.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def statistic_params
        params.require(:statistic).permit(:player_id, :match_id, :goals, :assists, :saves, :shots_on_target)
      end
    end
  end
end