# DbBench

Use to test Database

## Installation

Add this line to your application's Gemfile:

    gem 'db_bench'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install db_bench

## Usage

To benchmark mysql

  dbbench benchmark commands.csv result.csv user:password@host:port/database mysql
  
Output is a csv with the command + the timings

To extend with new Databases and queries implement a adapter with and interface according to the mysql one