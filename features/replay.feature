Feature: replay

  Scenario: replay
    Given DBbench is configured
    And I provide a replay file
    When I replay
    Then I should see results

  Scenario: replay incremental output
    Given DBbench is configured
    And I provide a replay file
    When I replay given a block
    Then I should see results

  @cassandra
  Scenario: replay cassandra
    Given DBbench is configured for cassandra
    And I provide a replay file for cassandra
    When I replay
    Then I should see results

