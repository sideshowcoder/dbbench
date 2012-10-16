Feature: generate records 

  When I implement benchmarks based on dbbench
  I want to be able to fill the database with records

  @wip
  Scenario: generate a record
    Given DBbench is configured
    When DBbech is called to generate a record
    Then A record should be added to the database
    

