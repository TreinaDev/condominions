module Api
  module V1
    class ResidentsController < Api::V1::ApiController
      def check_owner
        unless CPF.valid? params[:registration_number]
          return render status: :precondition_failed, json: nil
        end

        resident = Resident.find_by(registration_number: params[:registration_number])
        return render status: :not_found, json: nil if resident.nil?

        render status: :ok, json: nil
      end
    end
  end
end
