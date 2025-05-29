require 'rails_helper'

RSpec.describe 'Test Summary', type: :lib do
  describe 'Test Suite Overview' do
    it 'confirms test environment setup' do
      expect(Rails.env).to eq('test')
    end

    it 'confirms database connection' do
      expect(ActiveRecord::Base.connection).to be_connected
    end

    it 'confirms factory bot is working' do
      plan = build(:plan)
      expect(plan).to be_valid
    end

    it 'confirms basic models are loadable' do
      expect(Plan).to be < ApplicationRecord
      expect(User).to be < ApplicationRecord
      expect(WeeklyMenu).to be < ApplicationRecord
      expect(Frequency).to be < ApplicationRecord
    end

    it 'confirms test data can be created' do
      user = create(:user)
      expect(user).to be_persisted
      expect(user.plan).to be_present
      expect(user.frequency).to be_present
    end
  end
end 