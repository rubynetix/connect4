# Base Handler
class UserDoesNotExist < StandardError; end
class DuplicateUsers < StandardError; end

# User Handler
class InvalidUsername < StandardError; end

# Game Handler
class GameDoesNotExist < StandardError; end
class GameAlreadyInProgress < StandardError; end
class GameOver < StandardError; end
class InvalidTurn < StandardError; end

# League Handler
# N/A