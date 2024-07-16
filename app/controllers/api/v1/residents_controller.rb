module Api
  module V1
    class ResidentsController < Api::V1::ApiController
      def check_owner
        return render status: :precondition_failed, json: nil unless CPF.valid? params[:registration_number]

        resident = Resident.find_by(registration_number: params[:registration_number])
        return not_found if resident.nil?

        render status: :ok, json: nil
      end

      def get_residence
        return render status: :precondition_failed, json: nil unless CPF.valid? params[:registration_number]

        resident = Resident.find_by(registration_number: params[:registration_number])
        return not_found if resident.nil?

        residence = resident.residence
        unit_type = residence.unit_type
        condo = residence.condo
        render status: :ok, json: { resident: {name: resident.full_name, tenant_id: resident.id,
                                              residence: {
                                                          id: residence.id, 
                                                          area: unit_type.metreage,
                                                          floor: residence.floor.identifier,
                                                          number: residence.short_identifier,
                                                          unit_type_id: unit_type.id,
                                                          description: unit_type.description,
                                                          condo_id: condo.id,
                                                          condo_name: condo.name,
                                                          owner_id: residence.owner.id
                                                          }
                                              }
                                  }
      end
    end
  end
end
