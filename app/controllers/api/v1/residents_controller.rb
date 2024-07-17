module Api
  module V1
    class ResidentsController < Api::V1::ApiController
      def check_owner
        return render status: :precondition_failed, json: nil unless CPF.valid? params[:registration_number]

        resident = Resident.find_by(registration_number: params[:registration_number])
        return not_found if resident.nil?

        render status: :ok, json: nil
      end

      def tenant_residence
        return render status: :precondition_failed, json: nil unless CPF.valid? params[:registration_number]

        resident = Resident.find_by(registration_number: params[:registration_number])
        return not_found if resident.nil? || resident.residence.nil?

        residence = resident.residence
        unit_type = residence.unit_type
        condo = residence.condo
        render status: :ok, json: tenant_json(resident, residence, unit_type, condo)
      end

      def owner_properties
        return render status: :precondition_failed, json: nil unless CPF.valid? params[:registration_number]

        resident = Resident.find_by(registration_number: params[:registration_number])
        return not_found if resident.nil? || resident.properties.empty?

        render status: :ok, json: owner_json(resident)
      end

      private

      def tenant_json(resident, residence, unit_type, condo)
        { resident: { name: resident.full_name, tenant_id: resident.id,
                      residence: {
                        id: residence.id, area: unit_type&.metreage, floor: residence.floor.identifier,
                        number: residence.short_identifier, unit_type_id: unit_type&.id,
                        description: unit_type&.description, condo_id: condo.id,
                        condo_name: condo.name, owner_id: residence.owner&.id
                      } } }
      end

      def owner_json(resident)
        {
          resident: {
            name: resident.full_name,
            owner_id: resident.id,
            properties: resident.properties.map { |property| property_json(property) }
          }
        }
      end

      def property_json(property)
        unit_type = property.unit_type
        condo = property.condo
        {
          id: property.id, area: unit_type&.metreage, floor: property.floor.identifier,
          number: property.short_identifier, unit_type_id: unit_type&.id,
          description: unit_type&.description, condo_id: condo.id,
          condo_name: condo.name, tenant_id: property.tenant&.id
        }
      end
    end
  end
end
