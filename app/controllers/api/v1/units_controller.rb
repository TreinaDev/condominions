module Api
  module V1
    class UnitsController < Api::V1::ApiController
      def show
        unit = Unit.find_by(id: params[:id])
        return not_found if unit.nil?

        render status: :ok, json: unit.unit_json
      end
    end
  end
end
