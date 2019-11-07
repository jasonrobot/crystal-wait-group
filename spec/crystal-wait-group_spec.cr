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
end
