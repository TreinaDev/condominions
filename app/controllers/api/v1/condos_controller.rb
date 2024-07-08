module Api
  module V1
    class CondosController < Api::V1::ApiController
      def index
        render status: :ok, json: Condo.all.as_json(only: %i[id name],
                                                    methods: %i[city state])
      end

      def show
        condo = Condo.find_by id: params[:id]
        return render body: nil, status: :not_found if condo.nil?

        render status: :ok,
               json: condo.as_json(only: %i[name registration_number],
                                   include: { address: { only: %i[public_place
                                                                  number
                                                                  neighborhood
                                                                  city
                                                                  state
                                                                  zip] } })
      end
    end
  end
end
