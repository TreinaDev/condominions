module Api
  module V1
    class ResidentsController < Api::V1::ApiController
      def check_registration_number
        resident = Resident.find_by(registration_number: params[:registration_number])

        unless CPF.valid? params[:registration_number]
          return render status: :precondition_failed, json: { error: 'invalid registration number' }
        end

        return render status: :ok, json: { resident_type: 'inexistent' } if resident.nil?

        render status: :ok, json: resident.as_json(only: [:resident_type])
      end
    end
  end
end
