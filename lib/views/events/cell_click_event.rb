require_relative 'ui_event'

# Event for when a cell is clicked
class CellClickEvent < UIEvent
  attr_reader :row, :col

  def initialize(row, col)
    super UIEvent::CELL_CLICK
    @row = row
    @col = col
  end
end
