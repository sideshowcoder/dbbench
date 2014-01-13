# DBbench

Provide a framework for DB benchmarking on an application layer. It mainly
provides 2 functions:

  * provide a way to generate data
  * provide a way to replay predifined queries

It works by extenting the basis via a config and a couple of short classes to
inherit from the DBBench framework classes. This allows for quick random data
generation and replaying queries on the random set to provide a performance
overview.

This was used to get a feel for cassandra and mysql performance for a dataset,
and now it is open source, enjoy it and hack it!

## Installation

Installation works as easy as clone build install:

  $ git clone URL
  $ rake build
  $ gem install pkg/db\_ench\*

## Testing
You need to setup at least MySQL first, for the needed tables see

  $ rake setup:mysql

Cassandra is very version dependent so it is excluded for now

  $ rake spec
  $ rake features

Will run all the tests against MySQL

## Usage

For a basic usage checkout the spec/dummy example directory. Basically there
need to be:

  * dbbench.yml: configuration for the benchmark itself
  * database.yml: database configuration
  * play class: class to configure the plays to use for requests to run against
    the database
  * model class: class to be used for the model, like an ActiveRecord model for
    example
  * generator class: handle the datageneration, providing a lot of basics
    already but needs to be extended for costum types for example.
  * router class: route the mathing elements of the database layout to the
    mathing generator functions

For more on datageneration check out the tests and especially the enumerated
attributes to provide preprocessed data in an easy fashion.

## Benchmark

The benchmark provides the function to load a csv file with attributes and
process them via the play class to run against the database and record the
runtime.

## License

MIT

