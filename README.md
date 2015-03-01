# Standalone Maslow

This is a fork of [Maslow](https://github.com/alphagov/maslow), an app built by
the Government Digital Service to track the user needs behind GOV.UK.

This fork removes internal GDS dependencies and changes the app to store data
in its own database, rather than using the separate
[Need API](https://github.com/alphagov/govuk_need_api). This should make
it easier for other teams to set up their own instances.

## Caveats

- We've got here so far by crudely stripping out any internal dependencies and
merging some Need API behavior. This means that the test suite is out-of-date
and there's likely to be regressions.

- There's no user authentication feature: for simplicity, all sessions are
configured to use the same user in the database.

- We're currently missing the search and organisation filtering features. These
could be added back in the future.

- GOV.UK-specific questions have been removed from needs, such as the 'impact'
and 'justifications'.

## Dependencies

- Ruby (2.1.5)
- A running MongoDB instance
- Bundler

## Getting started

    bundle install
    bundle exec rails s -p 5000

## Configuration

- `INSTANCE_NAME`: the name to give to this instance of Maslow (eg. your team or
  product name).
- `DATABASE_URI`: the URL to a MongoDB database in the production environment

### Basic authentication

You can protect the app with HTTP Basic Authentication by setting the `USER` and
`PASSWORD` configurations appropriately in your environment.
