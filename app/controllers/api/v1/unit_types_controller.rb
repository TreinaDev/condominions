module Api
  module V1
    class UnitTypesController < Api::V1::ApiController
      def index
        return render body: nil, status: :not_found if Condo.find_by(id: params[:condo_id]).nil?

        render status: :ok,
               json: UnitType.where(condo_id: params[:condo_id])
                             .as_json(only: %i[id description metreage fraction],
                                      methods: [:unit_ids])
      end
    end
  end
end
