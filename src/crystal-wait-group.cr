# TODO: Write documentation for `Crystal::Wait::Group`
class WaitGroup
  @state = Atomic(Int32).new 0
  @mutex = Mutex.new

  def add(delta = 1)
    puts "in add where @state is #{@state.get}"
    # @mutex.synchronize do
      # puts "in sync block"
      @state.add(delta)
      if @state.get < 0
        raise "Less than 0 waits."
      end
    # end
  end

  def done
    puts "called done"
    add(-1)
  end

  def wait
    {% if flag?(:preview_mt) %}
    puts "in wait where @state is #{@state.get}"
    while @state.get != 0
      # puts "spinning!"
      Intrinsics.pause
      # Crystal::Scheduler.reschedule
    end
    {% end %}
  end

  def _spawn(&block)
    # yield
    add
    spawn do
      begin
        block.call
      ensure
        done
      end
      puts "after spawn"
    end
  end

end
