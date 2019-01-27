# Maslow Redux

[![Build Status](https://circleci.com/gh/JordanHatch/maslow-redux.svg?style=svg)](https://circleci.com/gh/JordanHatch/maslow-redux) [![Maintainability](https://api.codeclimate.com/v1/badges/a001835d1a0055c11bf9/maintainability)](https://codeclimate.com/github/JordanHatch/maslow-redux/maintainability)

This is a fork of [Maslow](https://github.com/alphagov/maslow), an app built by
the Government Digital Service to track the user needs behind GOV.UK.

This fork removes internal GDS dependencies and changes the app to store data
in its own database, rather than using the separate
[Need API](https://github.com/alphagov/govuk_need_api). This should make
it easier for other teams to set up their own instances.

## Dependencies

- Ruby (2.5.1)
- A running PostgreSQL instance

## Getting started

    # Installs gem dependencies, creates database tables, and creates the first
    # user account
    bin/setup

    # Starts the Maslow server
    foreman start

## Configuration

- `INSTANCE_NAME`: the name to give to this instance of Maslow (eg. your team or
  product name).
- `DATABASE_URI`: the URL to a PostgreSQL database in the production environment
- `FORCE_SSL`: when present, will force all requests to use SSL.
- `MASLOW_HOST`: the hostname on which Maslow is running, used to build URLs

### Email

- `EMAIL_FROM_ADDRESS`: the address which emails appear to be sent from
- `SMTP_HOST`: the hostname of the SMTP server used to send outbound emails
- `SMTP_USERNAME`: the username used to connect to the SMTP server
- `SMTP_PASSWORD`: the password used to connect to the SMTP server
- `SMTP_DOMAIN`: the HELO domain used when sending emails (optional)

### Analytics

- `GOOGLE_OAUTH_CLIENT_ID`: the client ID for your Google API Application
- `GOOGLE_OAUTH_SECRET_KEY`: the secret key for your Google API Application
- `GOOGLE_ANALYTICS_VIEW_ID`: the ID of the Google Analytics view you wish to retrieve data from
- `GOOGLE_OAUTH_REFRESH_TOKEN`: the access token for a user with access to the Google Analytics view. Run `bin/rake oauth:authorize` to obtain one.

### Basic authentication

In addition to the user authentication, you can protect the app with HTTP Basic
Authentication by setting the `USER` and `PASSWORD` configurations appropriately
in your environment.

## Tasks

### Importing needs from a CSV

You can import needs from a CSV with the correct headings. (See the example CSV
  in `spec/fixtures/files/need_import.csv` for a structure.)

To run the import task, run:

```
bin/rake import:needs[<url to csv>]
```

You can optionally increase the number of 'met when' criteria and need responses
to import by providing extra parameters. By default, up to 5 'met when' criteria
and 3 need responses are imported.

```
bin/rake import:needs[<url to csv>,<max responses>,<max met when criteria>]
```

## Major changes

- Data is now stored in a local PostgreSQL database, instead of making API
  requests to the Need API.

- The app has been upgraded to Rails 4.2, and includes a new RSpec test suite.

- The "need statuses" feature has been replaced with the ability to make
  separate decisions about whether a need is in scope, complete and being met.

- Organisation tagging has been replaced with a more flexible tagging feature,
  which allows for custom tag types to be created.

- User authentication is now provided by Devise instead of GOV.UK Signon.

- The notes, decisions and revisions for a need are displayed to users in a
  single feed for each need.

## Caveats

- We're currently missing the search and organisation filtering features. These
could be added back in the future.

- GOV.UK-specific questions have been removed from needs, such as the 'impact'
and 'justifications'.
