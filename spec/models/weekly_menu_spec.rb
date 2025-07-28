require 'rails_helper'

RSpec.describe WeeklyMenu, type: :model do
  describe 'validations' do
    subject { build(:weekly_menu) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:scheduled_date) }
  end

  describe 'associations' do
    it { should belong_to(:plan) }
    it { should belong_to(:frequency) }
  end

  describe 'factory' do
    it 'creates a valid weekly menu' do
      weekly_menu = build(:weekly_menu)
      expect(weekly_menu).to be_valid
    end

    it 'creates monday chest workout' do
      menu = build(:weekly_menu, :monday_chest)
      expect(menu.name).to eq('月曜日 - 胸')
      expect(menu.description).to include('ベンチプレス')
      expect(menu.scheduled_date).to eq(Date.current.beginning_of_week)
    end

    it 'creates tuesday back workout' do
      menu = build(:weekly_menu, :tuesday_back)
      expect(menu.name).to eq('火曜日 - 背中')
      expect(menu.description).to include('デッドリフト')
      expect(menu.scheduled_date).to eq(Date.current.beginning_of_week + 1.day)
    end

    it 'creates rest day' do
      menu = build(:weekly_menu, :rest_day)
      expect(menu.name).to eq('日曜日 - 休息')
      expect(menu.description).to include('完全休息日')
      expect(menu.scheduled_date).to eq(Date.current.beginning_of_week + 6.days)
    end
  end

  describe 'scopes' do
    let(:plan) { create(:plan) }
    let(:frequency) { create(:frequency) }
    let!(:monday_menu) { create(:weekly_menu, :monday_chest, plan: plan, frequency: frequency) }
    let!(:tuesday_menu) { create(:weekly_menu, :tuesday_back, plan: plan, frequency: frequency) }
    let!(:rest_menu) { create(:weekly_menu, :rest_day, plan: plan, frequency: frequency) }

    context 'when filtering by date' do
      it 'returns menus for specific week' do
        week_start = Date.current.beginning_of_week
        week_end = Date.current.end_of_week

        menus_in_week = WeeklyMenu.where(scheduled_date: week_start..week_end)
        expect(menus_in_week.count).to eq(3)
      end

      it 'returns menus for specific plan and frequency' do
        plan_frequency_menus = WeeklyMenu.for_plan_and_frequency(plan, frequency)
        expect(plan_frequency_menus.count).to eq(3)
      end
    end
  end

  describe 'instance methods' do
    let(:menu) { create(:weekly_menu) }

    it 'has required attributes' do
      expect(menu.name).to be_present
      expect(menu.description).to be_present
      expect(menu.scheduled_date).to be_present
      expect(menu.plan).to be_present
      expect(menu.frequency).to be_present
    end

    it 'returns day of week' do
      monday_menu = create(:weekly_menu, scheduled_date: Date.current.beginning_of_week)
      expect(monday_menu.scheduled_date.strftime('%A')).to eq('Monday')
    end
  end

  describe 'class methods' do
    let(:plan) { create(:plan) }
    let(:frequency) { create(:frequency) }

    before do
      create(:weekly_menu, plan: plan, frequency: frequency, scheduled_date: Date.current.beginning_of_week)
      create(:weekly_menu, plan: plan, frequency: frequency, scheduled_date: Date.current.beginning_of_week + 1.day)
      create(:weekly_menu, plan: plan, frequency: frequency, scheduled_date: Date.current.beginning_of_week + 2.days)
    end

    it 'groups menus by day of week' do
      grouped_menus = WeeklyMenu.all.group_by { |menu| menu.scheduled_date.wday }
      expect(grouped_menus.keys.length).to be >= 1
    end

    it 'filters by plan and frequency' do
      another_plan = create(:plan, name: 'Another Plan', title: 'Another Plan')
      another_frequency = create(:frequency, name: '週10回')
      create(:weekly_menu, plan: another_plan, frequency: another_frequency)

      filtered_menus = WeeklyMenu.for_plan_and_frequency(plan, frequency)
      expect(filtered_menus.count).to eq(3)
    end
  end
end
