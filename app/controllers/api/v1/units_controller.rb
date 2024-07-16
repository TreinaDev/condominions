module Api
  module V1
    class UnitsController < Api::V1::ApiController
      def index
        condo = Condo.find(params[:condo_id])
        return render body: nil, status: :not_found if condo.nil?

        unit_ids = condo.towers.flat_map { |tower| tower.floors.flat_map { |floor| floor.units.pluck(:id) } }

        render status: :ok, json: { unit_ids: }
      end
    end
  end
end
