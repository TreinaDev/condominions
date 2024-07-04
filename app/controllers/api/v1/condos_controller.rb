class Api::V1::CondosController < Api::V1::ApiController
  def index
    render status: :ok, json: Condo.all.as_json(only: %i[id name city state],
                                                include: { address: { only: %i[city state] } })
  end
end
