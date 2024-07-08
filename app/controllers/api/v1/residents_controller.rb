module Api
  module V1
    class ResidentsController < Api::V1::ApiController
      def check_registration_number
        resident = Resident.find_by(registration_number: params[:registration_number])
        return render status: :ok, json: { resident_type: 'inexistent' } if resident.nil?

        render status: :ok, json: resident.as_json(only: [:resident_type])
      end
    end
  end
end

#render status: :ok, json: Condo.all.as_json(only: %i[id name],
#                                                    methods: %i[city state])


#render status: :ok, json: Condo.all.as_json(only: %i[id name],
#                                                    methods: %i[city state])