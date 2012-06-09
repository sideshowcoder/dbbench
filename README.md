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

  dbbench benchmark commands.csv result.csv database.yml mysql
  dbbench benchmark [COMMANDFILE] [OUTPUTFILE] [DATABASECONFIG] [DATABASETYPE]
  
Output is a csv with the command + the timings
  
To create Data 
  
  dbbench generate database.yml mysql 100
  dbbench generate [DATABASECONFIG] [DATABASETYPE] [OPTIONAL NUMBEROFROWS]
  
Creates Entries in the Database to benchmark against

To extend with new Databases and queries implement a adapter with and interface according to the mysql one