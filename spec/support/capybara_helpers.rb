module CapybaraHelpers
  def fill_in_trix_editor(id, with:)
    find("##{id}").click.set(with)
  end
end

RSpec.configure do |config|
  config.include CapybaraHelpers, type: :system
end
