# DbBench

Fill Database with random Data and run Prerecorded queries against it to optimize for speed.

## Installation

Checkout the code
  
  $ git clone https://github.com/sideshowcoder/dbbench.git

Run rake to install 

  $ rake build && rake install

## Usage
    
    

### Generate Date

  $ dbbench generate [DATABASECONFIG] [DATABASETYPE] [OPTIONAL NUMBEROFROWS]

1. Create a Database Config file for the DB so ActiveRecord can connect see database.yml in example
2. Make sure the Database is setup correctly
3. Run: $ dbbench generate database.yml mysql 100
   This uses the database.yml file to connect, using the specified Adapter (mysql in this case) and create
   100 records.
  
### Benchmark

  $ dbbench benchmark [COMMANDFILE] [OUTPUTFILE] [DATABASECONFIG] [DATABASETYPE]

1. Create a command file with predefinded queries
2. Make sure the Database is setup correctly
3. Run: $ dbbench benchmark commands.csv result.csv database.yml mysql
   This with run the commands in commands.csv against the configured Database in this case MySQL and
   record the result in result.csv
  
### Extend

To extend with new Databases and queries implement a adapter with and interface according to the mysql one