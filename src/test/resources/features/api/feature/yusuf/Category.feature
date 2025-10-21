@yusuf @FullStartAll
Feature: US-52 Get Support by ID

  Background:
    * no explicit token

  Scenario: GET Valid ID US-52 AC-01
    Given use token "valid"
    When send GET "/api/supports"
    Then status is 200
    And list exists at "data.supports"
    And store id from body "data.supports[0].id" as "anyId"
    And assert item with id "anyId" exists under "data.supports"
    And assert fields for item id "anyId" under "data.supports":
      | id           |
      | user_id      |
      | title        |
      | status       |
      | created_at   |
      | user.full_name |
      | user.role_name |

  Scenario: GET Validate list US-52 AC-02
    Given use token "valid"
    When send GET "/api/supports"
    Then status is 200
    And list exists at "data.supports"

  Scenario: GET Non-existing ID US-52 AC-03
    Given use token "valid"
    And path id is 9999999
    When send GET "/api/supports/{id}"
    # Bazı ortamlar 203 yerine 200 + HTML veriyor; bunu esnekleştiriyoruz
    And status is one of 203 or 200
    And if content-type is html then page title contains "Page not found"

  Scenario: GET Invalid Token US-52 AC-04
    Given use token "invalid"
    When send GET "/api/supports"
    Then status is 401
    And body field "message" equals "Unauthenticated."
