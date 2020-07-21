# VersionedRoutes

`versioned-routes-rails` adds a single method to the Rails `routes.rb` DSL,`version`, which allows you to specify API versions.

When a user requests a specific version of an action, the closest version of that route is matched, starting with the requested version and going down to 1. This allows you to only specify a subset of routes to add or replace in subsequent API versions, allowing all the unmodified routes to fall through to the previous version.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'versioned-routes-rails'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install versioned-routes-rails

## Usage

`require 'versioned_routes'` in your `routes.rb` to load the `version` DSL.

Controllers must be namespaced as `VN::ThingController`, where `N` is the API version.

For example, let's define our V1 API as a set of `Message` resources, with some member actions. These will map to `V1::MessagesController`.

Our V2 API will only change the logic of `V1::MessagesController#show`, so we'll only specify that action in the `version 2` block. Requests to `/api/v2/messages/:id` will be routed to `V2::MessagesController#show`, while all other `/api/v2/messages` requests will still be routed to `V1::MessagesController`.

```ruby
require 'versioned_routes'

Rails.application.routes.draw do
  scope :api do
    version 1 do
      resources :messages do
        member do
          post :read
        end
      end
    end

    version 2 do
      resources :messages, only: [:show]
    end
  end
end
```

```bash
$ rake routes
```

<pre>
                   Prefix Verb   URI Pattern                                                                              Controller#Action
      read_v1_message POST   /api/v1/messages/:id/read(.:format)                                                  v1/messages#read {:format=>:json, :api_version=>1}
          v1_messages GET    /api/v1/messages(.:format)                                                           v1/messages#index {:format=>:json, :api_version=>1}
                          POST   /api/v1/messages(.:format)                                                           v1/messages#create {:format=>:json, :api_version=>1}
           v1_message GET    /api/v1/messages/:id(.:format)                                                       v1/messages#show {:format=>:json, :api_version=>1}
                          PATCH  /api/v1/messages/:id(.:format)                                                       v1/messages#update {:format=>:json, :api_version=>1}
                          PUT    /api/v1/messages/:id(.:format)                                                       v1/messages#update {:format=>:json, :api_version=>1}
                          DELETE /api/v1/messages/:id(.:format)                                                       v1/messages#destroy {:format=>:json, :api_version=>1}
           v2_message GET    /api/v2/messages/:id(.:format)                                                       v2/messages#show {:format=>:json, :api_version=>2}
      read_v2_message POST   /api/v2/messages/:id/read(.:format)                                                  v1/messages#read {:format=>:json, :api_version=>1}
          v2_messages GET    /api/v2/messages(.:format)                                                           v1/messages#index {:format=>:json, :api_version=>1}
                          POST   /api/v2/messages(.:format)                                                           v1/messages#create {:format=>:json, :api_version=>1}
                          PATCH  /api/v2/messages/:id(.:format)                                                       v1/messages#update {:format=>:json, :api_version=>1}
                          PUT    /api/v2/messages/:id(.:format)                                                       v1/messages#update {:format=>:json, :api_version=>1}
                          DELETE /api/v2/messages/:id(.:format)                                                       v1/messages#destroy {:format=>:json, :api_version=>1}
</pre>

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yasyf/versioned-routes-rails.

