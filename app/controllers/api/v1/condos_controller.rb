module Api
  module V1
    class CondosController < Api::V1::ApiController
      def index
        render status: :ok, json: Condo.all.as_json(only: %i[id name],
                                                    methods: %i[city state])
      end
    end
  end
end
