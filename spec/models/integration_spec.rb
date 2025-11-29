require 'rails_helper'

RSpec.describe Integration, type: :model do
  describe 'associations' do
    it { should belong_to(:project) }
    it { should belong_to(:created_by).class_name('User') }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:type) }
    it { should validate_inclusion_of(:type).in_array(Integration::TYPES) }

    context 'events validation' do
      it 'is valid with no events' do
        integration = build(:integration, events: [])
        expect(integration).to be_valid
      end

      it 'is valid with a subset of available events' do
        integration = build(:integration, events: [ Integration::AVAILABLE_EVENTS.first ])
        expect(integration).to be_valid
      end

      it 'is valid with all available events' do
        integration = build(:integration, events: Integration::AVAILABLE_EVENTS)
        expect(integration).to be_valid
      end

      it 'is invalid with an unknown event' do
        integration = build(:integration, events: [ 'unknown_event' ])
        expect(integration).not_to be_valid
        expect(integration.errors[:events]).to include("contains invalid events: unknown_event")
      end

      it 'is invalid when events is not an array' do
        integration = build(:integration, events: "not_an_array")
        expect(integration).not_to be_valid
        expect(integration.errors[:events]).to include("must be a list of events")
      end
    end
  end
end
