Feature: replay

  Scenario: replay
    Given DBbench is configured
    And I provide a replay file
    When I replay
    Then I should see results

    
