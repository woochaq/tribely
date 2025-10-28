class SetBoardKindBasedOnName < ActiveRecord::Migration[8.1]
  def self.up
    Board.find_each do |board|
      case board.try(:name)
      when "Current"
        board.kind = :current
      when "Backlog"
          board.kind = :backlog
      when "Icebox"
          board.kind = :icebox
      when "Done"
          board.kind = :done
      end
      board.save
    end
  end

  def self.down
  end
end
