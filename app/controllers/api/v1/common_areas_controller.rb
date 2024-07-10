module Api
  module V1
    class CommonAreasController < Api::V1::ApiController
      before_action :set_condo, only: [:index]
      before_action :set_common_area, only: [:show]

      def index
        return render body: nil, status: :not_found if @condo.nil?

        common_areas = fetch_common_areas

        render status: :ok, json: { condo_id: params[:condo_id], common_areas: }
      end

      def show
        return render body: nil, status: :not_found if @common_area.nil?

        render status: :ok, json: fetch_common_area(@common_area)
      end

      private

      def set_condo
        @condo = Condo.find_by id: params[:condo_id]
      end

      def set_common_area
        @common_area = CommonArea.find_by id: params[:id]
      end

      def fetch_common_areas
        CommonArea.where(condo_id: @condo.id).map do |area|
          fetch_common_area(area)
        end
      end

      def fetch_common_area(area)
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
