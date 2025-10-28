require 'rails_helper'

RSpec.describe Board, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:kind) }
  end

  describe "@done?" do
    let(:board) { FactoryBot.create(:board, kind: board_kind) }
    subject { board.done? }

    context "board kind is 'Done'" do
      let(:board_kind) { "done" }
      it { is_expected.to be_truthy }
    end

    context "board kind is not 'Done'" do
      let(:board_kind) { "current" }
      it { is_expected.to be_falsy }
    end
  end

  describe "@icebox?" do
    let(:board) { FactoryBot.create(:board, kind: board_kind) }
    subject { board.icebox? }

    context "board kind is 'Icebox'" do
      let(:board_kind) { "icebox" }
      it { is_expected.to be_truthy }
    end

    context "board kind is not 'Icebox'" do
      let(:board_kind) { "current" }
      it { is_expected.to be_falsy }
    end
  end
end
