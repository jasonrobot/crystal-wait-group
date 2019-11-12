require "fiber"

# WaitGroup can be used to wait for a number of different fibers to complete.
#
# Multiple fibers can be waited for, and multiple fibers can be waiting. Once
# there are no fibers being waited for
#
# ```
# wg = WaitGroup.new
# wg.spawn do
#   sleep 1
#   puts "slept for 1"
# end
#
# wg.add
# spawn do
#   sleep 2
#   puts "slept for 2"
#   wg.done
# end
#
# wg.wait
# puts "done waiting"
# ```
class WaitGroup
  # @state = Atomic(Int32).new 0
  @mutex = Mutex.new
  @waiting_fibers = Deque(Fiber).new
  @state = 0

  # Add `delta` to the number of fibers being waited for.
  #
  # Delta should be positive. Use `done` instead to decrement the counter.
  def add(delta = 1)
    @mutex.synchronize do
      @state += delta
    end
  end

  # Decrease the number of fibers being waited for by 1.
  #
  # This should be called from within the spawned fiber that's being waited for.
  # Once there are 0 fibers being waited for, all waiting fibers will be restarted.
  #
  # Raises an error if the counter goes below 0.
  def done
    @mutex.synchronize do
      @state -= 1
      if @state < 0
        # TODO use an exception type and not just a string.
        raise "Tried to decrement the number of fibers in a wait group below zero."
      end
      if @state == 0
        wake_waiting_fibers
      end
    end
  end

  private def wake_waiting_fibers
    Crystal::Scheduler.enqueue @waiting_fibers
    @waiting_fibers.clear
  end

  # Pause the current fiber until there are no fibers being waited for.
  #
  # If the counter is 0, `wait` will return immediately without blocking.
  # Multiple fibers can wait on the same wait group.
  def wait
    # This fiber can't be paused while the mutex is locked/synchronized, or else
    # it won't be released (and done can't restart waiting fibers), so use a
    # flag here.
    should_wait = false
    @mutex.synchronize do
      unless @state == 0
        @waiting_fibers << Fiber.current
        should_wait = true
      end
    end
    # This is probably a race condition. If another fiber decrements the counter
    # to 0 right now, this fiber will be forever paused.
    if should_wait
      Crystal::Scheduler.reschedule
    end
  end

  # Spawn a block in a fiber, calling `add` before it is spawned, and `done`
  # once it completes.
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
