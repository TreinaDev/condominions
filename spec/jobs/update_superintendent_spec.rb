require 'rails_helper'

RSpec.describe UpdateSuperintendentJob, type: :job do
  it '' do
    superintendent = create :superintendent
    UpdateSuperintendentJob.perfom(superintendent)
  end
end
