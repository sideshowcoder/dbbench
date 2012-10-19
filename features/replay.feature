Feature: replay

  When I provide a file with query parameters
  I want to be able to replay them on the current database

  Scenario: replay 
    Given DBbench is configured
    And I provide a replay file to replay
    When I replay a query
    Then I should see results

  Scenario: benchmark

