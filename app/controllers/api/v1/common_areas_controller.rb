module Api
  module V1
    class CommonAreasController < Api::V1::ApiController
      before_action :set_condo, only: [:index]
      before_action :set_common_area, only: [:show]

      def index
        return render body: nil, status: :not_found if @condo.nil?

        common_areas = @condo.common_areas.order :name

        render status: :ok, json: { common_areas: common_areas.as_json(only: %i[id name description]) }
      end

      def show
        return render body: nil, status: :not_found if @common_area.nil?

        render status: :ok, json: @common_area.as_json(only: %i[name description max_occupancy rules])
                                              .merge(condo_id: @common_area.condo_id)
      end

      private

      def set_condo
        @condo = Condo.find_by id: params[:condo_id]
      end

      def set_common_area
        @common_area = CommonArea.find_by id: params[:id]
      end
    end
  end
end
