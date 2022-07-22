# ConfigDefault

ConfigDefault is a simple way to separate your test/development config from your staging/production config.
Designed to work with [Rails](https://github.com/rails/rails). It depends on `ActiveSupport`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "config_default"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install config_default

## Configuration

You can control your configuration path and postfix which ConfigDefault will use.
Please use it in your `application.rb` file.
This example implement default values:

```ruby
ConfigDefault.configure do |config|
  config.config_path = "./config"
  config.postfix = "default"
end
```

If you want to implement Rails monkey patches for `Rails.application.config_for` and ability to
separate `database.yml` file you need to apply `#init_rails_monkey_patch!` method in your
`application.yml` file before application initialization.

```ruby
  ConfigDefault.init_rails_monkey_patch!
```

## Usage

### Default behaviour

First you need to separate you configuration to default and not.
Let's check an example for Rails default config file `config/database.yml`:

```yaml
# config/database.default.yml
default: &default
  adapter: postgres
  max_connections: 5
  host: postgres
  database: db

development:
  <<: *default
  database: db_development

test:
  <<: *default
  database: db_test

staging: *default

production: *default

public_production: *default
```

So this config file is enough for development/test environment.
But in staging/production you need to add other SECRET variables to this config.
Now you can do in your secret repository this:

```yaml
# config/database.yml
production:
  user: db_superuser
  password: db_password
```

All you need after creating this file in your secret location is to place this file near with
previous one. ConfigDefault will merge them automatically on startup.

### Your application configuration

Also `ConfigDefault` can help you with your application config and secrets.
Just create `config/app.default.yml` (test/staging) and `config/app.yml` (staging/production) files.
And then in your application load it:

```ruby
config = ConfigDefault.load(:app)
```

It will load result hash with merging `app.yml` and `app.default.yml` files.
By default `ConfigDefault` load YAML files as is.
So it's mean that what key (string or symbol) you will define in the YAML file => it'll be the same on `#load` result.

You can change this behaviour with `#load` options:
```ruby
config = ConfigDefault.load(:app, symbolize_keys: true) # Hash with symbolized first keys
config = ConfigDefault.load(:app, deep_symbolize_keys: true) # Hash with symbolized all keys
```

By default `ConfigDefault` using `Rails.env` to determnine what key you need from you config file.
You can pass this key by your own:
```ruby
config = ConfigDefault.load(:app, key: nil) # Will not use key at all and result by full file
config = ConfigDefault.load(:app, key: "preprod") # Will search preprod key in file
```

### `#load_struct` method

If you want to use configuration as a struct object you can use `#load_struct` method.
Let's see an example with `database.yaml` config above:

```ruby
config = ConfigDefault.load_struct(:database)
config.host
# => "postgres"
config.lolkek
# => StandardError: There is no option :lolkek in configuration.
```

If your want to not raise an error on wrong key using (sometimes it's helpful) please use `allow_nil` option:

```ruby
config = ConfigDefault.load_struct(:database, allow_nil: true)
config.host
# => "postgres"
config.lolkek
# => nil
```

If your need nested object using use `recursive` option on configuration load:

```yaml
# config/app.default.yml
first:
  second:
    third: "option"
```

```ruby
config = ConfigDefault.load_struct(:app, key: nil, recursive: true)
config.first.second.third
# => "option"
```

At any setting you can use `#to_hash` method to get a `Hash` for this configuration branch.
It will be `ActiveSupport::HashWithIndifferentAccess`.
Example with `app.default.yml` from above:

```ruby
config = ConfigDefault.load_struct(:app, key: nil, recursive: true)
config.to_hash
# => { "first" => { "second" => { "third" => "option" } } }
config.first.to_hash
# => { "second" => { "third" => "option" } }
config.first.second.to_hash
# => { "third" => "option" }
```

### Using `ConfigDefault::Struct` without configuration load

You can use `ConfigDefault::Struct` to achive ability to create config object from Hash objects.
Here an example of creation struct object on the fly:

```ruby
config_on_the_fly = { first: { second: { third: "option" } } }
config = ConfigDefault::Struct.new(attributes: config_on_the_fly, recursive: true)
config.first.to_hash
# => { "second" => { "third" => "option" } }
config.first.second.third
# => "option"
config.first.lolkek
# => StandardError: There is no option :lolkek in configuration.
```

`ConfigDefault::Struct` supports `recursive` and `allow_nil` options.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/skirushkin/config_default.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
