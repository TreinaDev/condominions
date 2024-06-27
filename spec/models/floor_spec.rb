require 'rails_helper'

RSpec.describe Floor, type: :model do
  describe '#valid?' do
    it 'Tower must be present' do
      floor = build :floor, tower: nil

      expect(floor).not_to be_valid
      expect(floor.errors.full_messages).to include 'Torre é obrigatório(a)'
    end
  end
end
