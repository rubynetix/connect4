require 'mysql2'

class MockDB
  class << self
    def no_result
      MockDB.one_result([])
    end

    def one_result(result)
      MockDB.new([result], :multi_query => false)
    end
  end

  def initialize(*results, multi_query: true)
    raise ArgumentError.new "Results must be enumerable" unless results.each { |r| r.is_a?(Enumerable) }
    @results = results
    @multiquery = multi_query
    @index = 0
  end

  def query(*args)
    res = @results[@index]
    @index += 1 if @multiquery
    res
  end

  def prepare(sql)
    self
  end

  alias_method :execute, :query

end
