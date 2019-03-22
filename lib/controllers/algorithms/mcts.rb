module MCTS
  EXPLORE_FACTOR = 2 # optimize
  MAX_ITERATIONS = 100

  def random_turn(board, turn)
    next_board = board.dup
    next_board.place(counter(turn), board.possible_moves.sample)
  end

  def counter(turn)
    return @counter if turn == 1
    return YellowCounter.instance if @counter == RedCounter.instance
    RedCounter.instance
  end

  class Node
    attr_accessor :board

    def initialize(board, parent = nil)
      @visits = 1
      @reward = 0.0
      @board = board
      @children = []
      @children_move = []
      @parent = parent
    end

    def add_child(c_board, move)
      child = Node(c_board, self)
      @children.append(child)
      @children_move.append(move)
    end

    def update(reward)
      @reward += reward
      @visits += 1
    end

    def fully_explored?
      return true if @children.size == @board.possible_moves.size

      false
    end
  end

  def get_reward(board, turn)
    while not board.draw? and not board.winner?
      board = random_turn(board, turn)
      turn *= -1
    end
    board.winner?
  end

  def get_score(node, child, explore_factor)
    exploit = child.reward / child.visits
    explore = Math.sqrt(Math.log(2.0 * node.visits) / child.visits)
    exploit + explore_factor * explore
  end

  def best_child(node, explore_factor)
    best_score = -Float::INFINITY
    best_index = []
    (0..node.children.size-1).each do |index|
      c = node.children[index]
      score = get_score node, c, explore_factor

      best_index.append(index) if score == best_score
      if score > best_score
        best_index = [index]
        best_score = score
      end
    end
    index = best_index.sample
    return node.children[index], node.children_move[index]
  end

  def expand(node, turn)
    tried_moves = node.children_move.dup
    possible_moves = node.state.possible_moves

    possible_moves.each do |move|
      unless tried_moves.include? move
        new_board = node.board.dup
        new_board.place(counter(turn), move)
        node.add_child new_board, move
        return node.children[-1]
      end
    end

    node.children[-1]
  end

  def tree_policy(node, turn, factor)
    while not node.board.draw? and not node.board.winner?
      return expand(node, turn), -turn unless node.fully_explored?

      node, _ = best_child node, factor
      turn *= -1
    end
  end

  def mcts(max_iterations, board_node, explore_factor)
    (1..max_iterations).each do
      front, turn = tree_policy board_node, 1, explore_factor
      reward = get_reward(front.state, turn)
    end

    puts board_node.children_move.to_s

    _, move = best_child board_node, 0
    move
  end

  def get_move(board)
    mcts MAX_ITERATIONS, Node(board), EXPLORE_FACTOR
  end
end