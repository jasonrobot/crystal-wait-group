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
    end
  end

  def done
    puts "done"
    @mutex.synchronize do
      puts "decrementing state"
      @state -= 1
      if @state < 0
        raise "Tried to decrement the number of fibers in a wait group below zero."
      end
      wake_waiting_fibers
    end
  end

  private def wake_waiting_fibers
    puts "restarting waiters"
    Crystal::Scheduler.enqueue @waiting_fibers
    @waiting_fibers.clear
  end

  def wait
    puts "waiting"
    @mutex.synchronize do
      unless @state == 0
        puts "pausing thread"
        @waiting_fibers << Fiber.current
      end
    end
    Crystal::Scheduler.reschedule
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
