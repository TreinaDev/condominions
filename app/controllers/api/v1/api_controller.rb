module Api
  module V1
    class ApiController < ActionController::API
      rescue_from ActiveRecord::ActiveRecordError, with: :internal_server_error

      def internal_server_error
        render body: nil, status: :internal_server_error
      end
    end
  end
end
