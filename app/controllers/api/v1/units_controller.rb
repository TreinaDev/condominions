module Api
  module V1
    class UnitsController < Api::V1::ApiController
      def index
        condo = Condo.find params[:condo_id]
        return render body: nil, status: :not_found if condo.nil?

        units = condo.towers.flat_map { |tower| tower.floors.flat_map(&:units) }

        render status: :ok, json: { units: units_json(units) }
      end

      private

      def units_json(units)
        units.map do |unit|
          {
            id: unit.id,
            floor: unit.floor.identifier,
            number: unit.short_identifier
          }
        end
      end
    end
  end
end
