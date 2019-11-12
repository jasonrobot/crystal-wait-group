crystal_doc_search_index_callback({"repository_name":"github.com/jasonrobot/crystal-wait-group","body":"# crystal-wait-group\n\nThis is a Crystal implementation of golang's sync.WaitGroup\n\nThere's probably still some work that needs to be done here, but it seems to work pretty well!\n\n## Installation\n\n1. Add the dependency to your `shard.yml`:\n\n   ```yaml\n   dependencies:\n     crystal-wait-group:\n       github: jasonrobot/crystal-wait-group\n   ```\n\n2. Run `shards install`\n\n## Usage\n\n```crystal\nrequire \"crystal-wait-group\"\n```\n\nTo use like Go's WaitGroup, there are the `add`, `done`, and `wait` methods. They should work just as expected.\n\n```\nwg = WaitGroup.new\nwg.add\nspawn do\n  sleep 1\n  wg.done\nend\nwg.wait\n```\n\nAs a fun crystal-style addition, there is also a `spawn` method which takes a block and spawns it in a fiber that is waited for by the WaitGroup.\n\n```\nwg = WaitGroup.new\nwg.spawn do\n  sleep 1\nend\nwg.wait\n```\n\n## Development\n\nAll feedback is welcome! This is my first time playing with concurrency at this level, or doing low-level Crystal stuff, so there's gotta be room for improvment. The usage of `Intrinsics.pause` is taken from `Crystal::SpinLock`. Basically what I've gone for here is a version of SpinLock built around an atomic counter.\n\n## Contributing\n\n1. Fork it (<https://github.com/jasonrobot/crystal-wait-group/fork>)\n2. Create your feature branch (`git checkout -b my-new-feature`)\n3. Commit your changes (`git commit -am 'Add some feature'`)\n4. Push to the branch (`git push origin my-new-feature`)\n5. Create a new Pull Request\n\n## Contributors\n\n- [Jason Howell](https://github.com/jasonrobot) - creator and maintainer\n","program":{"html_id":"github.com/jasonrobot/crystal-wait-group/toplevel","path":"toplevel.html","kind":"module","full_name":"Top Level Namespace","name":"Top Level Namespace","abstract":false,"superclass":null,"ancestors":[],"locations":[],"repository_name":"github.com/jasonrobot/crystal-wait-group","program":true,"enum":false,"alias":false,"aliased":"","const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":null,"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[{"html_id":"github.com/jasonrobot/crystal-wait-group/WaitGroup","path":"WaitGroup.html","kind":"class","full_name":"WaitGroup","name":"WaitGroup","abstract":false,"superclass":{"html_id":"github.com/jasonrobot/crystal-wait-group/Reference","kind":"class","full_name":"Reference","name":"Reference"},"ancestors":[{"html_id":"github.com/jasonrobot/crystal-wait-group/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"github.com/jasonrobot/crystal-wait-group/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"crystal-wait-group.cr","line_number":4,"url":"https://github.com/jasonrobot/crystal-wait-group/blob/66834662884278b76047c1c90d4befb28bafb788/src/crystal-wait-group.cr"}],"repository_name":"github.com/jasonrobot/crystal-wait-group","program":false,"enum":false,"alias":false,"aliased":"","const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":null,"doc":"TODO: Write documentation for `Crystal::Wait::Group`","summary":"<p><span class=\"flag orange\">TODO</span>  Write documentation for <code>Crystal::Wait::Group</code></p>","class_methods":[],"constructors":[],"instance_methods":[{"id":"add(delta=1)-instance-method","html_id":"add(delta=1)-instance-method","name":"add","doc":null,"summary":null,"abstract":false,"args":[{"name":"delta","doc":null,"default_value":"1","external_name":"delta","restriction":""}],"args_string":"(delta = <span class=\"n\">1</span>)","source_link":"https://github.com/jasonrobot/crystal-wait-group/blob/66834662884278b76047c1c90d4befb28bafb788/src/crystal-wait-group.cr#L10","def":{"name":"add","args":[{"name":"delta","doc":null,"default_value":"1","external_name":"delta","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"@mutex.synchronize do\n  @state = @state + delta\nend"}},{"id":"done-instance-method","html_id":"done-instance-method","name":"done","doc":null,"summary":null,"abstract":false,"args":[],"args_string":"","source_link":"https://github.com/jasonrobot/crystal-wait-group/blob/66834662884278b76047c1c90d4befb28bafb788/src/crystal-wait-group.cr#L17","def":{"name":"done","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"@mutex.synchronize do\n  @state = @state - 1\n  if @state < 0\n    raise(\"Tried to decrement the number of fibers in a wait group below zero.\")\n  end\n  if @state == 0\n    wake_waiting_fibers\n  end\nend"}},{"id":"spawn(&block)-instance-method","html_id":"spawn(&amp;block)-instance-method","name":"spawn","doc":null,"summary":null,"abstract":false,"args":[],"args_string":"(&block)","source_link":"https://github.com/jasonrobot/crystal-wait-group/blob/66834662884278b76047c1c90d4befb28bafb788/src/crystal-wait-group.cr#L52","def":{"name":"spawn","args":[],"double_splat":null,"splat_index":null,"yields":0,"block_arg":{"name":"block","doc":null,"default_value":"","external_name":"block","restriction":""},"return_type":"","visibility":"Public","body":"add\n::spawn do\n  begin\n    block.call\n  ensure\n    done\n  end\nend\n"}},{"id":"wait-instance-method","html_id":"wait-instance-method","name":"wait","doc":null,"summary":null,"abstract":false,"args":[],"args_string":"","source_link":"https://github.com/jasonrobot/crystal-wait-group/blob/66834662884278b76047c1c90d4befb28bafb788/src/crystal-wait-group.cr#L37","def":{"name":"wait","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"should_wait = false\n@mutex.synchronize do\n  if @state == 0\n  else\n    @waiting_fibers << Fiber.current\n    should_wait = true\n  end\nend\nif should_wait\n  Crystal::Scheduler.reschedule\nend\n"}}],"macros":[],"types":[]}]}})