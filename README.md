# Tribely

Project management app built with Rails 8.

## Running locally

Development and test use SQLite, so no database server is needed.

### Requirements

- Ruby 4.0.9 (see `.ruby-version`; `mise install` or `rbenv install` will pick it up)
- [libvips](https://www.libvips.org/install.html) for image variants (avatars)
  - macOS: `brew install vips`
  - Debian/Ubuntu: `sudo apt install libvips`
  - Arch: `sudo pacman -S libvips`

### Setup

```sh
git clone https://github.com/woochaq/tribely.git
cd tribely
bin/setup
```

`bin/setup` installs gems, creates the SQLite database in `storage/` and starts the
app (Rails server + Tailwind watcher) at http://localhost:3000.

Next time, start the app with:

```sh
bin/dev
```

No `config/master.key` is needed locally. Encrypted credentials are only used in production.

### Creating an account

1. Sign up at http://localhost:3000.
2. The app requires email confirmation. In development, emails are not sent but
   caught by [letter_opener_web](https://github.com/fgrosse/letter_opener_web).
   Open http://localhost:3000/letter_opener and click the confirmation link.

Or confirm the user from the Rails console:

```sh
bin/rails console
```

```ruby
User.find_by!(email: "you@example.com").confirm
```

To confirm every pending user at once:

```ruby
User.where(confirmed_at: nil).find_each(&:confirm)
```

### Tests and checks

```sh
bundle exec rspec   # test suite
bin/rubocop         # lint
bin/brakeman        # security scan
```

## Production

Production runs on MySQL and is deployed with [Kamal](https://kamal-deploy.org).
The `mysql2` gem lives in an optional Gemfile group, enabled in the Docker image via
`BUNDLE_WITH=mysql`. To install it locally: `bundle config set --local with mysql`.

Deploy needs:

- `config/master.key` (or `RAILS_MASTER_KEY`)
- `KAMAL_SERVER_IP` environment variable with the target server address
- secrets listed in `.kamal/secrets`

```sh
KAMAL_SERVER_IP=<server ip> bin/kamal deploy
```
