require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe 'validations' do
    subject { build(:plan) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:users) }
    it { should have_many(:weekly_menus) }
  end

  describe 'factory' do
    it 'creates a valid plan' do
      plan = build(:plan)
      expect(plan).to be_valid
    end

    it 'creates health maintenance plan' do
      plan = build(:plan, :health_maintenance)
      expect(plan.name).to eq('健康維持')
      expect(plan.title).to eq('健康維持')
      expect(plan.description).to eq('ライトなトレーニングプラン')
    end

    it 'creates diet plan' do
      plan = build(:plan, :diet)
      expect(plan.name).to eq('ダイエット')
      expect(plan.title).to eq('ダイエット')
      expect(plan.description).to eq('バランスの取れたトレーニングプラン')
    end

    it 'creates muscle building plan' do
      plan = build(:plan, :muscle_building)
      expect(plan.name).to eq('ゴリマッチョ')
      expect(plan.title).to eq('ゴリマッチョ')
      expect(plan.description).to eq('ハードトレーニングプラン')
    end
  end

  describe 'scopes or class methods' do
    before do
      create(:plan, :health_maintenance)
      create(:plan, :diet)
      create(:plan, :muscle_building)
    end

    it 'returns all plans' do
      expect(Plan.count).to eq(3)
    end
  end
end
