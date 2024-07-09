module Api
  module V1
    class ResidentsController < Api::V1::ApiController
      def check_registration_number
        unless CPF.valid? params[:registration_number]
          return render status: :precondition_failed, json: { error: 'invalid registration number' }
        end

        resident = Resident.find_by(registration_number: params[:registration_number])
        return render status: :not_found, json: { resident_type: 'inexistent', unit_id: 'nil' } if resident.nil?

        render status: :ok, json: resident.as_json(only: %i[resident_type unit_id])
      end
    end
  end
end
