require 'rails_helper'

RSpec.describe Announcement, type: :model do
  describe '#valid?' do
    it 'missing params' do
      announcement = Announcement.new title: '', message: ''

      expect(announcement).not_to be_valid
      expect(announcement.errors[:title]).to include 'não pode ficar em branco'
      expect(announcement.errors[:message]).to include 'não pode ficar em branco'
    end

    it 'title longer than 50 characters' do
      announcement = Announcement.new title: 'a' * 51

      expect(announcement).not_to be_valid
      expect(announcement.errors[:title]).to include 'é muito longo (máximo: 50 caracteres)'
    end
  end
end
