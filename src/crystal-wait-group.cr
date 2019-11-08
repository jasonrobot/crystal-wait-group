require "fiber"

# TODO: Write documentation for `Crystal::Wait::Group`
class WaitGroup
  # @state = Atomic(Int32).new 0
  @mutex = Mutex.new
  @waiting_fibers = Deque(Fiber).new
  @state = 0

  def add(delta = 1)
    @mutex.synchronize do
      @state += delta
      # puts "state is #{@state}"
    end
  end

  def done
    # puts "done"
    @mutex.synchronize do
      # puts "decrementing state from #{@state}"
      @state -= 1
      if @state < 0
        raise "Tried to decrement the number of fibers in a wait group below zero."
      end
      if @state == 0
        wake_waiting_fibers
      end
    end
  end

  private def wake_waiting_fibers
    # puts "restarting waiters"
    Crystal::Scheduler.enqueue @waiting_fibers
    @waiting_fibers.clear
  end

  def wait
    # puts "waiting"
    should_wait = false
    @mutex.synchronize do
      unless @state == 0
        # puts "pausing thread"
        @waiting_fibers << Fiber.current
        should_wait = true
      end
    end
    if should_wait
      Crystal::Scheduler.reschedule
    end
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
