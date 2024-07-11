module Api
  module V1
    class ResidentsController < Api::V1::ApiController
      def check_owner
        return render status: :precondition_failed, json: nil unless CPF.valid? params[:registration_number]

        resident = Resident.find_by(registration_number: params[:registration_number])
        return not_found if resident.nil?

        render status: :ok, json: nil
      end
    end
  end
end
