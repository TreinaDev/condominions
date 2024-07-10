module Api
  module V1
    class CommonAreasController < Api::V1::ApiController
      before_action :set_condo, only: [:index]

      def index
        return render body: nil, status: :not_found if @condo.nil?

        common_areas = fetch_common_areas

        render status: :ok, json: { condo_id: params[:condo_id], common_areas: }
      end

      private

      def set_condo
        @condo = Condo.find_by id: params[:condo_id]
      end

      def fetch_common_areas
        CommonArea.where(condo_id: @condo.id).map do |area|
          {
            id: area.id,
            name: area.name,
            description: area.description,
            max_occupancy: area.max_occupancy,
            rules: area.rules
          }
        end
      end
    end
  end
end
