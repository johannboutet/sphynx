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

### Middleware

To use the authentication middleware provided by Sphynx, just add `Sphynx::Middleware` to your middleware stack.

For example in a Grape API app, add this line in you main api file:
```ruby
class Api < Grape::API
  use Sphynx::Middleware

  # rest of your API here
end
```

For a Rails app, add this line to your `config/application.rb` file:
```ruby
config.middleware.insert_after ActiveRecord::Migration::CheckPending, Sphynx::Middleware
```

### Configuration

Sphynx requires a bit a configuration to know about your models and api routes. This can be done in an initializer for a Rails app, or before calling `run` on your app in your rack file for a Grape app.

Sphynx exposes a `.configure` method which passes the config object to the given block.

```ruby
Sphynx.configure do |config|
  config.dispatch_requests = [['POST', /^login$/], ['GET', /^refresh$/]]
  config.revocation_requests = [['GET', /^logout$/]]
  config.secret = ENV['MY_APP_SECRET']
  config.scopes = {
    user: {
      user_class: User,
      provider_class: AuthProvider
    },
    admin: {
      user_class: User,
      provider_class: AuthProvider
    }
  }
end
```

Here is a list of available config options:

| Attribute | Required | Description | Default value |
| --------- | -------- | ----------- | ------------- |
| `secret` | yes | The secret to be used to sign the JWTs. We recommend using a different one than your app's main secret. |
| `dispatch_requests` | no | An array representing the routes on which Sphynx should dispatch a new JWT in the response headers. Each item in the array must be a two items array: the first indicates the HTTP verb of the request, the second is a regex to match against the request URL. | `[]` |
| `revocation_requests` | no | Same as `dispatch_requests`, but for the requests on which you want to invalidate the JWT present in the request headers. | `[]` |
| `scopes` | no | A hash of scopes you want to use to authenticate users. More details bellow. | See bellow. |
| `failure_app` | no | A basic Rack app to call when the JWT authentication fails. | `->(env) { [401, { 'Content-Type' => 'application/json' }, [{ error: 'unauthorized', message: (env['warden.options'][:message] || 'Unauthorized') }.to_json]] }` |
| `google_client_id` | no | If you want to use Google as an OAuth provider, your Google App API key. |

## Scopes

Scopes are used by Warden to allow multiple users to be logged in at the same time for the same request. Most of the times you'll only need one scope, but in more advanced cases it can be useful, for example if you want to have separated `user` and `admin` user kinds, and allow an admin to impersonate and sign in as a user, while still being signed in with his admin account.

Scopes are also used by Sphynx to make it aware of your models. A scope must have 3 attributes:
- `user_class`: The class that represents your User model. Can be any ruby class as long as it implements the required methods (see bellow).
- `provider_class`: The class that represents your OAuth model. Can be any ruby class as long as it implements the required methods (see bellow).
- `revocation_strategy`: The class that represents your JWT revocation strategy. Can be any ruby class as long as it implements the required methods (see bellow). This one is actually optional and will default to `Sphynx::RevocationStrategies::NullStrategy` (no revocation strategy).

The default value for the `scopes` config is:
```ruby
{
  user: {
    user_class: User,
    provider_class: AuthProvider,
    revocation_strategy: Sphynx::RevocationStrategies::NullStrategy
  }
}
```
Which means that Sphynx will expect a `User` class and a `AuthProvider` class by default, and have no revocation strategy.

## User class

Your user class must answer to the following class methods:
- `.find_for_jwt_authentication(sub)` -  this method will be passed the `sub` claim of the JWT
- `.jwt_subject` - this method must return what will be encoded in the `sub` claim of the JWT, and then used to retrieve the user 

## Usage


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/johannboutet/sphynx. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sphynx project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/sphynx/blob/master/CODE_OF_CONDUCT.md).
