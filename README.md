# Maslow Redux

[![Build Status](https://circleci.com/gh/JordanHatch/maslow-redux.svg?style=svg)](https://circleci.com/gh/JordanHatch/maslow-redux) [![Maintainability](https://api.codeclimate.com/v1/badges/a001835d1a0055c11bf9/maintainability)](https://codeclimate.com/github/JordanHatch/maslow-redux/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/a001835d1a0055c11bf9/test_coverage)](https://codeclimate.com/github/JordanHatch/maslow-redux/test_coverage)

Maslow Redux lets your team document, discuss and track the performance of your
users' needs.

This is a fork of [Maslow](https://github.com/alphagov/maslow), an app built by
the Government Digital Service to track the user needs behind GOV.UK. You can
see the GOV.UK user needs in action on the 'info' pages - eg.
[gov.uk/info/register-to-vote](https://www.gov.uk/info/register-to-vote).

## Dependencies

- Ruby (2.5.3)
- A running PostgreSQL instance

## Getting started

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

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
