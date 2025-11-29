require 'rails_helper'

RSpec.describe Integration, type: :model do
  describe 'associations' do
    it { should belong_to(:project) }
    it { should belong_to(:created_by).class_name('User') }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:type) }
  end
end
