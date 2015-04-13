# Rack::Toolbar

Allows you to create simple Rack Middleware that will insert HTML (or whatever!) into responses at specific points.

This gem was extracted from [Rack::Insight](https://github.com/pboling/rack-insight).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-toolbar'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-toolbar

## Usage

If your app is delivering a response like:

    <html>
      <head></head>
      <body>
        <h1>Important</h1>
      </body>
    </html>

### Simple Setup

You want to inject something into the response!

Configure your app to use Rack::Toolbar

    use Rack::Toolbar, {snippet: "<div>More Important!</div>", insertion_point: "<body>", insertion_method: :after}

The `div` specified will be injected `:after` the `<body` tag.

    <html>
      <head></head>
      <body>
        <div>More Important!</div>
        <h1>Important</h1>
      </body>
    </html>

### Easy Setup

You want to build a Middleware that will deliver a custom response based on whatever.

Create your middleware to inherit from Rack::Toolbar, and define a `render` method:

    class CustomMiddleware < Rack::Toolbar
      def render
        "<script>javascript:void(0)</script>"
      end
    end

Configure your app to use your CustomMiddleware.  You can still use the `:insertion_*` options, but `:snippet` will be ignored.

    use CustomMiddleware, {insertion_point: "</head>", insertion_method: :before}

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/destination_errors/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Make sure to add tests!
6. Create a new Pull Request

## Contributors

See the [Network View](https://github.com/pboling/rack-toolbar/network)
