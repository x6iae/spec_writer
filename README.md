# SpecWriter

We know you don't do TDD :stuck_out_tongue: but what about DDT? :smile: 

We can help you DDT so you can TDD.

SpecWriter is a tool aimed to help in promoting the art of TDD, by first helping to compile the most basic tests ( supporting only model tests for now ) for your new rails application, so you can continue on the testing path as you progress in the development process.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spec_writer', group: development
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spec_writer
    
## Dependencies
The usage of this gem depends on the use of the following tools/frameworks:

1. Rails
2. [Rspec-rails](https://github.com/rspec/rspec-rails) ( the testing framework for rails > 3.0 )
3. [Factory-Girls](https://github.com/thoughtbot/factory_girl_rails)

Others that might be useful, but not entirely compulsory includes:

 - Database cleaner
 - Faker

## Usage

In a rails application, set up the rspec testing, with factories in the `spec/factories` directory...

Next, to have SpecWriter compile model test for a model, simply run: `$ rails generate model_spec MODEL`. (generating for User model, for example, will be: `$ rails generate model_spec User`) this will generate a spec file in the `spec/models/<model>_spec.rb` and populate with some good basic tests.

#### Tests covered are:
 - Validation tests
 - Association tests
 - Graceful destroyals for associated models ( This is usually useful to identify where the `dependent: destroy` option has been omited so as to avoid the common `update or delete on table "<table>" violates foreign key constraint` error on a resource.)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SundayAdefila/spec_writer.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

