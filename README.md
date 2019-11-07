# crystal-wait-group

This is a Crystal implementation of golang's sync.WaitGroup

There's probably still some work that needs to be done here, but it seems to work pretty well!

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     crystal-wait-group:
       github: jasonrobot/crystal-wait-group
   ```

2. Run `shards install`

## Usage

```crystal
require "crystal-wait-group"
```

To use like Go's WaitGroup, there are the `add`, `done`, and `wait` methods. They should work just as expected.

```
wg = WaitGroup.new
wg.add
spawn do
  sleep 1
  wg.done
end
wg.wait
```

As a fun crystal-style addition, there is also a `spawn` method which takes a block and spawns it in a fiber that is waited for by the WaitGroup.

```
wg = WaitGroup.new
wg.spawn do
  sleep 1
end
wg.wait
```

## Development

All feedback is welcome! This is my first time playing with concurrency at this level, or doing low-level Crystal stuff, so there's gotta be room for improvment. The usage of `Intrinsics.pause` is taken from `Crystal::SpinLock`. Basically what I've gone for here is a version of SpinLock built around an atomic counter.

## Contributing

1. Fork it (<https://github.com/your-github-user/crystal-wait-group/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Jason Howell](https://github.com/your-github-user) - creator and maintainer
