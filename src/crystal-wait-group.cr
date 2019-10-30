# TODO: Write documentation for `Crystal::Wait::Group`
class WaitGroup
  @state = Atomic(Int32).new 0
  @mutex = Mutex.new

  def add(delta = 1)
    @state.add(delta)
    if @state.get < 0
      raise "Tried to decrement the number of fibers in a wait group below zero."
    end
  end

  def done
    add(-1)
  end

  def wait
    {% if flag?(:preview_mt) %}
    while @state.get != 0
      Intrinsics.pause
    end
    {% end %}
  end

  def spawn(&block)
    add
    ::spawn do
      begin
        block.call
      ensure
        done
      end
    end
  end

end
