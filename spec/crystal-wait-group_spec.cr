require "./spec_helper"

describe WaitGroup do
  # TODO: Write tests

  it "works" do
    wg = WaitGroup.new
    wg.add
    spawn do
      sleep 2
      wg.done
    end
    wg.spawn do
      puts "sleeping in block"
      sleep 1
      puts "done sleeping in block"
    end
    puts "calling wait"
    wg.wait
    puts "wait done"
  end

  describe "number of fibers being waited on" do

    [1, 2, 3, 4, 8].each do |count|

      it "waits for #{count} fibers" do
        wg = WaitGroup.new
        counter = Atomic(Int32).new 0

        count.times do
          wg.add
          spawn do
            sleep 50.milliseconds
            counter.add 1
            wg.done
          end
        end
        wg.wait
        counter.get.should eq count
      end
    end
  end
end
