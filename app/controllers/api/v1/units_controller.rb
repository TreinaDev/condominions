module Api
  module V1
    class UnitsController < Api::V1::ApiController
      def show
        unit = Unit.find_by(id: params[:id])
        return not_found if unit.nil?

        render status: :ok, json: unit_json(unit)
      end

      private

      def unit_json(unit)
        unit_type = unit.unit_type
        condo = unit.condo
        {
          id: unit.id, area: unit_type&.metreage,
          floor: unit.floor.identifier, number: unit.short_identifier,
          unit_type_id: unit_type&.id, condo_id: condo.id,
          condo_name: condo.name, tenant_id: unit.tenant&.id,
          owner_id: unit.owner&.id, description: unit_type&.description
        }
      end
    end
  end
end
