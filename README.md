# SassyHash

SassHash takes a normal ruby hash and maps is keys and values into Sass Values for injection into Sass maps.

## Examples

```ruby
  ::Sass::Script::Value::Map.new(SassyHash[:foo => :bar])
```

```ruby
  some_hash = {:foo => :bar}
  ::Sass::Script::Value::Map.new(SassyHash[some_hash)
```
## Installation

Add this line to your application's Gemfile:

    gem 'sassy_hash'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sassy_hash

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
