Feature: generate records

  When I implement benchmarks based on dbbench
  I want to be able to fill the database with records

  Scenario: generate a record in mysql
    Given DBbench is configured
    When DBbench is called to generate a record
    Then A record should be added to the database

  @cassandra
  Scenario: generate a record in cassandra
    Given DBbench is configured for cassandra
    When DBbench is called to generate a record in cassandra
    Then the record should be found

