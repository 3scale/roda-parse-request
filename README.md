# roda-parse-request

[roda](http://roda.jeremyevans.net/) plugin which automatically parses JSON and url-encoded requests


## Usage

In your `Gemfile`:

```ruby
gem 'roda-parse-request'
```


In your roda app:

```ruby
require 'roda'
require 'roda-parse-request'

class App < Roda
  plugin :parse_request

  route do |r|

    r.post do
      # You can use request.parsed_body here
      # By default, it will contain response.body parsed as a json or url-encoded
      # request (if the request was sent with the appropiate content-type headers)
    end
  end
end
```


## Customization

It is possible to add your own parsers to the plugin, like so:

```ruby
require 'roda'
require 'roda-parse-request'

class App < Roda
  plugin :parse_request, parsers: {
    'upcase'  => ->(data) { data.upcase },
  }

  route do |r|

    r.post do
      # You can still use json and url-encoded parsed requests in request.parsed_body
      # But now, if you get a request with Content-Type = 'upcase', the body
      # will be automatically set to all caps.
    end
  end
end
```

See the specs for more examples

## Running specs

Clone the repo, run `bundle` and then `rspec`.


## License

MIT License (see LICENSE)

