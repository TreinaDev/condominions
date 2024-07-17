module Api
  module V1
    class UnitsController < Api::V1::ApiController
      def index
        condo = Condo.find params[:condo_id]
        return render body: nil, status: :not_found if condo.nil?

        render status: :ok, json: { units: condo.units_json }
      end

      def show
        unit = Unit.find_by(id: params[:id])
        return not_found if unit.nil?

        render status: :ok, json: unit.unit_json
      end
    end
  end
end
