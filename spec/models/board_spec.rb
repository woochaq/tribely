require 'rails_helper'

RSpec.describe Board, type: :model do
  describe "@done?" do
    let(:board) { FactoryBot.create(:board, name: board_name) }
    subject { board.done? }

    context "board name is 'Done'" do
      let(:board_name) { "Done" }
      it { is_expected.to be_truthy }
    end

    context "board name is not 'Done'" do
      let(:board_name) { "Current" }
      it { is_expected.to be_falsy }
    end
  end

  describe "@icebox?" do
    let(:board) { FactoryBot.create(:board, name: board_name) }
    subject { board.icebox? }

    context "board name is 'Icebox'" do
      let(:board_name) { "Icebox" }
      it { is_expected.to be_truthy }
    end

    context "board name is not 'Icebox'" do
      let(:board_name) { "Current" }
      it { is_expected.to be_falsy }
    end
  end
end
