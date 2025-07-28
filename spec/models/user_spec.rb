require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_uniqueness_of(:username) }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe 'associations' do
    it { should belong_to(:plan) }
    it { should belong_to(:frequency) }
  end

  describe 'factory' do
    it 'creates a valid user' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'creates user with health plan' do
      user = create(:user, :with_health_plan)
      expect(user.plan.name).to eq('健康維持')
    end

    it 'creates user with diet plan' do
      user = create(:user, :with_diet_plan)
      expect(user.plan.name).to eq('ダイエット')
    end

    it 'creates user with muscle building plan' do
      user = create(:user, :with_muscle_plan)
      expect(user.plan.name).to eq('ゴリマッチョ')
    end
  end

  describe 'instance methods' do
    let(:user) { create(:user) }

    it 'has required attributes' do
      expect(user.email).to be_present
      expect(user.name).to be_present
      expect(user.username).to be_present
      expect(user.plan).to be_present
      expect(user.frequency).to be_present
    end

    it 'authenticates with valid password' do
      expect(user.valid_password?('password123')).to be true
    end

    it 'does not authenticate with invalid password' do
      expect(user.valid_password?('wrongpassword')).to be false
    end
  end

  describe 'callbacks or custom validations' do
    it 'downcases email before saving' do
      user = create(:user, email: 'TEST@EXAMPLE.COM')
      expect(user.email).to eq('test@example.com')
    end
  end
end
