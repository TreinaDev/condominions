module Api
  module V1
    class ApiController < ActionController::API
      rescue_from ActiveRecord::ActiveRecordError, with: :internal_server_error
      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      def internal_server_error
        render body: nil, status: :internal_server_error
      end

      def not_found
        render body: nil, status: :not_found
      end
    end
  end
end
