# README
The application demonstrates proper domain modeling, validation boundaries, and safe database migrations using Ruby on Rails.

Ruby Version

Ruby: 3.4.8

Managed via mise

Verify with:

ruby -v

System Dependencies

The following are required to run the application:

Ruby 3.4.x

Bundler

SQLite3

Node.js (for Rails asset pipeline, if needed)

Install dependencies using:

bundle install

Configuration

No additional environment variables are required for local development.

Default Rails configuration is used.

Database Creation

Create the database using:

bin/rails db:create

Database Initialization

Run all migrations to set up schema, constraints, and indexes:

bin/rails db:migrate


To verify migration safety:

bin/rails db:rollback
bin/rails db:migrate

How to Run the Test Suite

This project does not include automated tests as part of Assignment-05.

Validation and integrity checks are performed manually using the Rails console:

bin/rails console


Example:

Patient.create!(name: "Test User", email: "test@example.com")


Invalid records raise ActiveRecord::RecordInvalid.

Services

This application does not rely on external services.

No job queues, cache servers, or search engines are configured.

All logic is handled using:

Active Record validations

Database constraints

Deployment Instructions

Deployment is out of scope for Assignment-05.

The application is intended to run locally for schema and validation review only.

Project Documentation

Detailed assignment walkthrough, schema rationale, and validation logic are documented in:

docs/assignment-5.md

Notes for Reviewers

Model-level and DB-level validations are both implemented

Overlapping appointments are prevented

Migrations are reversible and safe

Schema supports real-world scheduling workflows

* ...
