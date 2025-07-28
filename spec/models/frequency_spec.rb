require 'rails_helper'

RSpec.describe Frequency, type: :model do
  describe 'validations' do
    subject { build(:frequency) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:users) }
  end

  describe 'factory' do
    it 'creates a valid frequency' do
      frequency = build(:frequency)
      expect(frequency).to be_valid
    end

    it 'creates once a week frequency' do
      frequency = build(:frequency, :once_a_week)
      expect(frequency.name).to eq('週1回')
    end

    it 'creates two to three times frequency' do
      frequency = build(:frequency, :two_to_three_times)
      expect(frequency.name).to eq('週2~3回')
    end

    it 'creates four to five times frequency' do
      frequency = build(:frequency, :four_to_five_times)
      expect(frequency.name).to eq('週4~5回')
    end

    it 'creates six to seven times frequency' do
      frequency = build(:frequency, :six_to_seven_times)
      expect(frequency.name).to eq('週6~7回')
    end
  end

  describe 'class methods' do
    before do
      create(:frequency, :once_a_week)
      create(:frequency, :two_to_three_times)
      create(:frequency, :four_to_five_times)
      create(:frequency, :six_to_seven_times)
    end

    it 'returns all frequency options' do
      expect(Frequency.count).to eq(4)
      expect(Frequency.pluck(:name)).to match_array([
        '週1回', '週2~3回', '週4~5回', '週6~7回'
      ])
    end
  end

  describe 'instance methods' do
    let(:frequency) { create(:frequency, :two_to_three_times) }

    it 'has required attributes' do
      expect(frequency.name).to be_present
      expect(frequency.name).to eq('週2~3回')
    end

    it 'can be associated with users' do
      user = create(:user, frequency: frequency)
      expect(frequency.users).to include(user)
      expect(user.frequency).to eq(frequency)
    end
  end
end
