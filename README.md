[![Build Status](https://travis-ci.org/johannboutet/sphynx.svg?branch=master)](https://travis-ci.org/johannboutet/sphynx)
[![codecov](https://codecov.io/gh/johannboutet/sphynx/branch/master/graph/badge.svg)](https://codecov.io/gh/johannboutet/sphynx)

# Sphynx

Sphynx is a gem designed to help you integrate JSON Web Token (JWT) and OAuth authentication in your API. It was created with Rails and Grape apps in mind, but it should be able to work with any Rack application easily.

## How does it work

Sphynx basically consists of a Rack middleware and some helper classes. The middleware handles user authentication through JWT with Warden and the helper classes are here to help you use OAuth providers.

The first time a user tries to authenticate, the request should send a payload including an OAuth provider name (Google, Facebook, etc.) and a token. Use the helper classes (or your own) to validate this token and sign in the user.

Once the user is signed in, the middleware kicks in and dispatches a JWT in the headers of the response. This JWT should then be used by your front-end application to authenticate the user in each subsequent request.

Sphynx also supports JWT revocation if you want to mark a JWT as invalid when a user signs out.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sphynx'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sphynx

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sphynx. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sphynx project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/sphynx/blob/master/CODE_OF_CONDUCT.md).
