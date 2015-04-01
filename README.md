# Standalone Maslow [![Build Status](https://travis-ci.org/JordanHatch/maslow-standalone.png?branch=master)](https://travis-ci.org/JordanHatch/maslow-standalone)

This is a fork of [Maslow](https://github.com/alphagov/maslow), an app built by
the Government Digital Service to track the user needs behind GOV.UK.

This fork removes internal GDS dependencies and changes the app to store data
in its own database, rather than using the separate
[Need API](https://github.com/alphagov/govuk_need_api). This should make
it easier for other teams to set up their own instances.

## Dependencies

- Ruby (2.1.5)
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

### Basic authentication

You can protect the app with HTTP Basic Authentication by setting the `USER` and
`PASSWORD` configurations appropriately in your environment.

## Major changes

- Data is now stored in a local PostgreSQL database, instead of making API
  requests to the Need API.

- The app has been upgraded to Rails 4.2, and a new RSpec test suite is being
  worked on.

- The "organisations" functionality is being replaced by a broader tagging
  feature.

- The code is being gradually refactored now that we are no longer making
  requests to an external API.

## Caveats

- We're currently missing the search and organisation filtering features. These
could be added back in the future.

- GOV.UK-specific questions have been removed from needs, such as the 'impact'
and 'justifications'.
