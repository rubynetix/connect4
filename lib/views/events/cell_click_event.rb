# Event for when a cell is clicked
class CellClickEvent
  attr_reader :row, :col

  def initialize(row, col)
    @row = row
    @col = col
  end
end
